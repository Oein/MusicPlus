//
//  ReccentlyAdded.swift
//  musicplus
//
//  Created by oein on 1/22/25.
//

import SwiftUI
import MusicKit
import WrappingHStack

struct CatAlbumBody: View {
    @ObservedObject private var state = ApplicationMusicPlayer.shared.state
    @State var my = false;
    
    func play() {
        if my {
            MusicKit.ApplicationMusicPlayer.shared.pause()
            my = false;
        } else {
            Task {
                MusicKit.ApplicationMusicPlayer.shared.queue = [album]
                try await MusicKit.ApplicationMusicPlayer.shared.play()
                my = true;
            }
        }
    }
    
    @State var album: Album;
    var body: some View {
        VStack {
            HStack {
                Button(action: play) {
                    VStack {
                        if state.playbackStatus == .playing {
                            Image(systemName: "pause.fill")
                                .padding(12)
                        } else {
                            Image(systemName: "play.fill")
                                .padding(12)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .background(Color.servicePrimary)
                .clipShape(.circle)
                VStack(alignment: .leading) {
                    Text(album.title)
                        .font(.satoshiBold28)
                    HStack {
                        Group {
                            Text("By")
                                .foregroundStyle(Color.foregroundSecondary)
                            Text(album.artistName)
                                .bold()
                        }
                        Text("·")
                            .foregroundStyle(Color.foregroundSecondary)
                        Group {
                            Text(album.trackCount.formatted())
                            Text("Songs")
                                .foregroundStyle(Color.foregroundSecondary)
                        }
                    }
                    .font(.satoshiRegular14)
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            ScrollView {
                SearchResultsView(results: (album.tracks ?? []).compactMap({ track in
                    return .track(track)
                }))
                .frame(alignment: .topLeading)
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct CatAlbumCover: View {
    @State var album: Album;
    var body: some View {
        VStack {
            if album.artwork != nil {
                AsyncImage(
                    url: album.artwork!.url(width: 512, height: 512),
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
#if os(macOS)
                            .frame(maxWidth: 256, maxHeight: 256)
#else
                            .frame(maxWidth: .infinity)
#endif
                            .clipShape(.rect(cornerRadius: 6))
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
                .frame(width: 256, height: 256, alignment: .center)
            }
            WrappingHStack(album.genreNames, id: \.self, lineSpacing: 8) { item in
                VStack {
                    Text(item)
                        .padding(8)
                        .padding(.horizontal, 4)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(.white, lineWidth: 1)
                )
            }
#if os(macOS)
            .frame(width: 256, alignment: .topLeading)
#else
            .frame(alignment: .topLeading)
#endif
        }
#if os(macOS)
        .frame(width: 256)
#endif
    }
}

struct CatAlbum: View {
    @State var fetching = false;
    @State var lastkwd = "";
    @State var album: Album? = nil;
    @State var trycnt = 0;
    
    var body: some View {
        Layout {
            if fetching {
                ProgressView()
                Text("Fetching..." + (trycnt > 0 ? " (Tried " + String(trycnt) + " times)" : ""))
            }
            else if album != nil {
#if os(macOS)
                HStack(alignment: .top, spacing: 8) {
                    CatAlbumBody(album: album!)
                    CatAlbumCover(album: album!)
                }
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .topLeading)
#else
                VStack(alignment: .leading, spacing: 8) {
                    CatAlbumCover(album: album!)
                    CatAlbumBody(album: album!)
                }
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .topLeading)
#endif
            }
        }
        .onAppear(perform: {
            fetchAlbum()
        })
    }
    
    func fetchAlbum() {
        if fetching {
            if lastkwd == WPath.shared.queryparm {
                return;
            }
        }
        
        lastkwd = WPath.shared.queryparm;
        fetching = true;
        trycnt = 0;
        
        let myval = WPath.shared.queryparm
        let mid = MusicItemID(rawValue: myval)
        var albumReq = MusicKit.MusicCatalogResourceRequest<Album>(matching: \.id, equalTo: mid);
        albumReq.properties = [.tracks]
        
        Task {
            while trycnt < 3 {
                do {
                    let albumData = try await albumReq.response()
                    if WPath.shared.queryparm != myval {
                        return
                    }
                    if albumData.items.count == 0 {
                        // no album data
                        album = nil;
                        break;
                    } else {
                        album = albumData.items[0]
                        break;
                    }
                    
                } catch {
                    trycnt += 1;
                }
            }
            
            fetching = false;
        }
    }
}
