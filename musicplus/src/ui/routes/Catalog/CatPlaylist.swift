//
//  ReccentlyAdded.swift
//  musicplus
//
//  Created by oein on 1/22/25.
//

import SwiftUI
import MusicKit
import WrappingHStack

struct CatPlaylistBody: View {
    @ObservedObject private var state = ApplicationMusicPlayer.shared.state
    @State var my = false;
    
    func play() {
        if my {
            MusicKit.ApplicationMusicPlayer.shared.pause()
            my = false;
        } else {
            Task {
                MusicKit.ApplicationMusicPlayer.shared.queue = [playlist]
                try await MusicKit.ApplicationMusicPlayer.shared.play()
                my = true;
            }
        }
    }
    
    @State var playlist: Playlist;
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
                    Text(playlist.name)
                        .font(.satoshiBold28)
                    HStack {
                        Group {
                            Text((playlist.entries ?? []).count.formatted())
                            Text("Songs")
                                .foregroundStyle(Color.foregroundSecondary)
                        }
                    }
                    .font(.satoshiRegular14)
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            ScrollView {
                SearchResultsView(results: (playlist.tracks ?? []).compactMap({ track in
                    return .track(track)
                }))
                .frame(alignment: .topLeading)
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct CatPlaylistCover: View {
    @State var album: Playlist;
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
            Text(album.standardDescription ?? "")
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

struct CatPlaylist: View {
    @State var fetching = false;
    @State var lastkwd = "";
    @State var playlist: Playlist? = nil;
    @State var trycnt = 0;
    
    var body: some View {
        Layout {
            if fetching {
                HStack(alignment: .center) {
                    Spacer()
                    VStack(alignment: .center) {
                        Spacer()
                        ProgressView()
                        Text("Fetching..." + (trycnt > 0 ? " (Tried " + String(trycnt) + " times)" : ""))
                        Spacer()
                    }
                    Spacer()
                }
            }
            else if playlist != nil {
#if os(macOS)
                HStack(alignment: .top, spacing: 8) {
                    CatPlaylistBody(playlist: playlist!)
                    CatPlaylistCover(album: playlist!)
                }
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .topLeading)
#else
                VStack(alignment: .leading, spacing: 8) {
                    CatPlaylistCover(album: album!)
                    CatPlaylistBody(album: album!)
                }
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .topLeading)
#endif
            }
        }
        .onAppear(perform: {
            fetchPlaylist()
        })
    }
    
    func fetchPlaylist() {
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
        var playReq = MusicKit.MusicCatalogResourceRequest<Playlist>(matching: \.id, equalTo: mid);
        playReq.properties = [.tracks]
        
        Task {
            while trycnt < 3 {
                do {
                    let playlistData = try await playReq.response()
                    if WPath.shared.queryparm != myval {
                        return
                    }
                    if playlistData.items.count == 0 {
                        // no album data
                        playlist = nil;
                        break;
                    } else {
                        playlist = playlistData.items[0]
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
