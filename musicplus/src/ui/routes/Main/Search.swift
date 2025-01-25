//
//  Search.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import SwiftUI
import MusicKit

struct Search: View {
    @State var fetching: Bool = false;
    @State var trycnt: Int = 0;
    @State var catalog: MusicCatalogSearchResponse? = nil;
    @State var results: [MusicItemAny] = [];
    @State var seltag: Int = 0;
    @State var page: Int = 0;
    @State var hasmore: Bool = true;
    @State var lastkwd: String = "";
    
    func acl_bg(my: Int) -> Color {
        if seltag == my {
            return Color.white
        }
        return Color.backgroundPrimary
    }
    
    func acl_fg(my: Int) -> Color {
        if seltag == my {
            return Color.black
        }
        return Color.foregroundPrimary
    }
    
    func btnact(tag: Int) -> () -> Void {
        return {
            seltag = tag;
            catalog = nil;
            page = 0;
            results = [];
            hasmore = true;
            fetchResult()
        }
    }
    
    var body: some View {
        Layout {
            ScrollView(.horizontal) {
                HStack {
                    Button(action: btnact(tag: 0), label: {
                        Text("No Filter")
                            .padding(8)
                            .padding(.horizontal, 4)
                            .foregroundStyle(acl_fg(my: 0))
                    })
                    .buttonStyle(.plain)
                    .background(acl_bg(my: 0))
                    
                    Button(action: btnact(tag: 1), label: {
                        Text("Stations")
                            .padding(8)
                            .padding(.horizontal, 4)
                            .foregroundStyle(acl_fg(my: 1))
                    })
                    .buttonStyle(.plain)
                    .background(acl_bg(my: 1))
                    
                    Button(action: btnact(tag: 2), label: {
                        Text("Artists")
                            .padding(8)
                            .padding(.horizontal, 4)
                            .foregroundStyle(acl_fg(my: 2))
                    })
                    .buttonStyle(.plain)
                    .background(acl_bg(my: 2))
                    
                    Button(action: btnact(tag: 3), label: {
                        Text("Albums")
                            .padding(8)
                            .padding(.horizontal, 4)
                            .foregroundStyle(acl_fg(my: 3))
                    })
                    .buttonStyle(.plain)
                    .background(acl_bg(my: 3))
                    
                    Button(action: btnact(tag: 4), label: {
                        Text("Songs")
                            .padding(8)
                            .padding(.horizontal, 4)
                            .foregroundStyle(acl_fg(my: 4))
                    })
                    .buttonStyle(.plain)
                    .background(acl_bg(my: 4))
                }
                .padding(8)
            }
            
            if seltag == 0 && catalog != nil {
                Catalog(catalog: catalog)
            } else if seltag != 0 {
                SearchResultsView(results: results)
                    .frame(alignment: .topLeading)
                    .frame(maxWidth: .infinity)
            }
            
            if WPath.shared.queryparm == "" {
                Text("Search anything you want")
                    .padding(8)
                    .font(.satoshiMedium18)
            } else if fetching {
                VStack(alignment: .center) {
                    ProgressView()
                    Text("Fetching..." + (trycnt > 0 ? " (Tried " + String(trycnt) + " times)" : ""))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(8)
            }
            
            if hasmore {
                SPCE()
                SPCE()
                SPCE()
            }
        }
        .onAppear(perform: fetchResult)
        .onAppear(perform: applyTimer)
        .onDisappear(perform: disapplyTimer)
        .onChange(of: WPath.shared.queryparm, fetchResult)
    }
    
    func applyTimer() {
        MusicKitManager.shared.infscrollTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            if MusicKitManager.shared.requiredsearchmore {
                fetchResult()
                MusicKitManager.shared.requiredsearchmore = false;
            }
        });
    }
    
    func disapplyTimer() {
        MusicKitManager.shared.infscrollTimer?.invalidate()
    }
    
    func tys() -> [any MusicCatalogSearchable.Type] {
        if seltag == 0 {
            return [Song.self, Album.self, Artist.self, Playlist.self, Station.self];
        }
        if seltag == 1 {
            return [Station.self];
        }
        if seltag == 2 {
            return [Artist.self];
        }
        if seltag == 3 {
            return [Album.self];
        }
        if seltag == 4 {
            return [Song.self];
        }
        
        return [Song.self, Album.self, Artist.self, Playlist.self, Station.self];
    }
    
    func fetchResult() {
        if WPath.shared.queryparm == "" {
            return;
        }
        let reqText = WPath.shared.queryparm;
        if lastkwd != reqText {
            hasmore = true;
            results = [];
            catalog = nil;
            fetching = false;
            page = 0;
            lastkwd = reqText;
        }
        if !hasmore {
            return;
        }
        if fetching {
            return;
        }
        
        fetching = true;
        trycnt = 0;
        Task {
            while fetching == true && trycnt < 3 {
                var request = MusicCatalogSearchRequest(
                    term: reqText,
                    types: tys()
                )
                
                if seltag == 0 {
                    request.includeTopResults = true;
                    hasmore = false;
                }
                else {
                    request.limit = 25;
                    request.offset = page * 25;
                }
                
                do {
                    let response = try await request.response()
                    if WPath.shared.queryparm != reqText {
                        return
                    }
                    fetching = false;
                    trycnt = 0;
                    
                    if seltag == 0 {
                        catalog = response;
                    }
                    print("Search about " + reqText)
                    
                    switch seltag {
                    case 1:
                        hasmore = response.stations.hasNextBatch
                        results = results + response.stations.compactMap({ val in
                            return .station(val);
                        })
                        break;
                    case 2:
                        hasmore = response.artists.hasNextBatch
                        results = results + response.artists.compactMap({ val in
                            return .artist(val);
                        })
                        break;
                    case 3:
                        hasmore = response.albums.hasNextBatch
                        results = results + response.albums.compactMap({ val in
                            return .album(val);
                        })
                        break;
                    case 4:
                        hasmore = response.songs.hasNextBatch
                        results = results + response.songs.compactMap({ val in
                            return .song(val);
                        })
                        break;
                    default:
                        hasmore = false;
                        break;
                    }
                    
                    page += 1;
                } catch {
                    print("Search failed: \(error)")
                }
            }
        }
    }
}

struct SPCE: View {
    var body: some View {
        VStack {} .frame(height: 32)
    }
}
