//
//  Search.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import SwiftUI
import MusicKit

enum MusicItemAny {
    case album(Album)
    case artist(Artist)
    case curator(Curator)
    case musicVideo(MusicVideo)
    case playlist(Playlist)
    case radioShow(RadioShow)
    case recordLabel(RecordLabel)
    case song(Song)
    case station(Station)
    
    func canBePlayed() -> Bool {
        switch self {
        case .song:
            return true
        case .album:
            return true
        case .playlist:
            return true
        case .station:
            return true
        default:
            return false
        }
    }
}

struct Search: View {
    @State var fetching = false;
    @State var trycnt = 0;
    @State var catalog: MusicCatalogSearchResponse? = nil;
    
    var body: some View {
        Layout {
            if PathManager.shared.queryparm == "" {
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
            } else if catalog != nil {
                VStack(alignment: .leading) {
                    if catalog!.topResults.count > 0 {
                        Text(catalog!.topResults.title ?? "Top results")
                            .font(.satoshiBold28)
                        SearchResults(results: catalog!.topResults.compactMap {
                            switch $0 {
                            case .album(let album):
                                return MusicItemAny.album(album);
                            case .artist(let artist):
                                return MusicItemAny.artist(artist);
                            case .curator(let curator):
                                return MusicItemAny.curator(curator);
                            case .musicVideo(let musicVideo):
                                return MusicItemAny.musicVideo(musicVideo);
                            case .playlist(let playlist):
                                return MusicItemAny.playlist(playlist);
                            case .radioShow(let radioShow):
                                return MusicItemAny.radioShow(radioShow);
                            case .recordLabel(let recordLabel):
                                return MusicItemAny.recordLabel(recordLabel);
                            case .song(let song):
                                return MusicItemAny.song(song);
                            case .station(let station):
                                return MusicItemAny.station(station);
                            default:
                                return nil;
                            }
                        })
                        .frame(maxWidth: .infinity)
                        SPCE()
                    }
                    
                    if catalog!.artists.count > 0 {
                        Text(catalog!.artists.title ?? "Artists")
                            .font(.satoshiBold28)
                        SearchResults(results: catalog!.artists.compactMap {
                            return .artist($0)
                        })
                        .frame(maxWidth: .infinity)
                        SPCE()
                    }
                    
                    if catalog!.albums.count > 0 {
                        Text(catalog!.albums.title ?? "Albums")
                            .font(.satoshiBold28)
                        SearchResults(results: catalog!.albums.compactMap {
                            return .album($0)
                        })
                        .frame(maxWidth: .infinity)
                        SPCE()
                    }
                    
                    if catalog!.songs.count > 0 {
                        Text(catalog!.songs.title ?? "Songs")
                            .font(.satoshiBold28)
                        SearchResults(results: catalog!.songs.compactMap {
                            return .song($0)
                        })
                        .frame(maxWidth: .infinity)
                        SPCE()
                    }
                    
                    if catalog!.stations.count > 0 {
                        Text(catalog!.stations.title ?? "Stations")
                            .font(.satoshiBold28)
                        SearchResults(results: catalog!.stations.compactMap {
                            return .station($0)
                        })
                        .frame(maxWidth: .infinity)
                        SPCE()
                    }
                    
                    if catalog!.playlists.count > 0 {
                        Text(catalog!.playlists.title ?? "Playlists")
                            .font(.satoshiBold28)
                        SearchResults(results: catalog!.playlists.compactMap {
                            return .playlist($0)
                        })
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(8)
                .frame(alignment: .topLeading)
            }
        }
        .onAppear(perform: fetchResult)
        .onChange(of: PathManager.shared.queryparm, fetchResult)
    }
    
    func fetchResult() {
        if PathManager.shared.queryparm == "" {
            return;
        }
        fetching = true;
        trycnt = 0;
        let reqText = PathManager.shared.queryparm;
        Task {
            while fetching == true && trycnt < 3 {
                var request = MusicCatalogSearchRequest(term: reqText, types: [Song.self, Album.self, Artist.self, Playlist.self, Station.self])
                request.includeTopResults = true;
                do {
                    let response = try await request.response()
                    if PathManager.shared.queryparm != reqText {
                        return
                    }
                    fetching = false;
                    trycnt = 0;
                    
                    catalog = response;
                    print("Search about " + reqText)
                    print(response)
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
