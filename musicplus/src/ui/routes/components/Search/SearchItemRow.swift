//
//  RecoItem.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import Foundation
import SwiftUI
import MusicKit

struct SearchItemRow: View {
    var recoitem: MusicItemAny;
    
    func getName() -> String {
        switch recoitem {
        case .station(let station):
            return station.name
        case .album(let album):
            return album.title
        case .artist(let artist):
            return artist.name
        case .curator(let curator):
            return curator.name
        case .musicVideo(let musicVideo):
            return musicVideo.title
        case .playlist(let playlist):
            return playlist.name
        case .radioShow(let radioShow):
            return radioShow.name
        case .recordLabel(let recordLabel):
            return recordLabel.name
        case .song(let song):
            return song.title
        case .track(let track):
            return track.title
        }
    }
    
    func getCreaterName() -> String? {
        switch recoitem {
        case .album(let album):
            return album.artistName
        case .artist(let artist):
            return artist.name
        case .curator(let curator):
            return curator.name
        case .musicVideo(let musicVideo):
            return musicVideo.artistName
        case .playlist(let playlist):
            return playlist.curatorName
        case .radioShow(let radioShow):
            return radioShow.hostName
        case .recordLabel(_):
            return nil
        case .song(let song):
            return song.artistName
        case .track(let track):
            return track.artistName
        case .station(_):
            return nil
        }
    }
    
    var body: some View {
        Button(action: {
            switch recoitem {
            case .album(let album):
                WPath.shared.goto(path: "album", qparm: album.id.rawValue)
                break;
            case .artist(let artist):
                WPath.shared.goto(path: "artist", qparm: artist.id.rawValue)
                break;
            case .curator(_):
                print("Pressed a curator")
                break;
            case .musicVideo(_):
                print("Pressed a musicvideo")
                break;
            case .playlist(let playlist):
                WPath.shared.goto(path: "playlist", qparm: playlist.id.rawValue)
                break;
            case .radioShow(_):
                print("Pressed a radio show")
                break;
            case .recordLabel(_):
                print("Pressed a recordLabel")
                break;
            case .song(let song):
                Task {
                    MusicKit.ApplicationMusicPlayer.shared.queue = [song];
                    try await MusicKit.ApplicationMusicPlayer.shared.play();
                }
                break;
            case .track(let track):
                Task {
                    MusicKit.ApplicationMusicPlayer.shared.queue = [track];
                    try await MusicKit.ApplicationMusicPlayer.shared.play();
                }
                break;
            case .station(let station):
                Task {
                    MusicKit.ApplicationMusicPlayer.shared.queue = [station];
                    try await MusicKit.ApplicationMusicPlayer.shared.play();
                }
                break;
            }
        }) {
            HStack(alignment: .center) {
                // Artwork
                switch recoitem {
                case .station(let station):
                    if station.artwork != nil {
                        SearchItemRowArtwork(artwork: station.artwork!, recoitem: recoitem)
                    }
                case .album(let album):
                    if album.artwork != nil {
                        SearchItemRowArtwork(artwork: album.artwork!, recoitem: recoitem)
                    }
                case .artist(let artist):
                    if artist.artwork != nil {
                        SearchItemRowArtwork(artwork: artist.artwork!, recoitem: recoitem)
                    }
                case .curator(let curator):
                    if curator.artwork != nil {
                        SearchItemRowArtwork(artwork: curator.artwork!, recoitem: recoitem)
                    }
                case .musicVideo(let musicVideo):
                    if musicVideo.artwork != nil {
                        SearchItemRowArtwork(artwork: musicVideo.artwork!, recoitem: recoitem)
                    }
                case .playlist(let playlist):
                    if playlist.artwork != nil {
                        SearchItemRowArtwork(artwork: playlist.artwork!, recoitem: recoitem)
                    }
                case .radioShow(let radioShow):
                    if radioShow.artwork != nil {
                        SearchItemRowArtwork(artwork: radioShow.artwork!, recoitem: recoitem)
                    }
                case .recordLabel(let recordLabel):
                    if recordLabel.artwork != nil {
                        SearchItemRowArtwork(artwork: recordLabel.artwork!, recoitem: recoitem)
                    }
                case .song(let song):
                    if song.artwork != nil {
                        SearchItemRowArtwork(artwork: song.artwork!, recoitem: recoitem)
                    }
                case .track(let track):
                    if track.artwork != nil {
                        SearchItemRowArtwork(artwork: track.artwork!, recoitem: recoitem)
                    }
                }
                
                // Title
                VStack(alignment: .center) {
                    Text(getName())
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    if getCreaterName() != nil {
                        Text(getCreaterName()!)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                }
                
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .buttonStyle(.plain)
    }
}

struct SearchItemRowArtwork: View {
    @State var hovered = false;
    @State var hoveredPlayBTN = false;
    @State var appear = false;
    var artwork: Artwork;
    var recoitem: MusicItemAny;
    
    func onHov(hovVal: Bool) {
        hovered = hovVal;
    }
    
    func onHovPlay(hovVal: Bool) {
        hoveredPlayBTN = hovVal;
    }
    
    func onVischange(vis: Bool) {
        appear = appear || vis;
    }
    
    func play_self() {
        Task {
            var play = true;
            switch recoitem {
            case .song(let song):
                MusicKit.ApplicationMusicPlayer.shared.queue = [song];
                break;
            case .album(let album):
                MusicKit.ApplicationMusicPlayer.shared.queue = [album];
                break;
            case .playlist(let playlist):
                MusicKit.ApplicationMusicPlayer.shared.queue = [playlist];
                break;
            case .station(let station):
                MusicKit.ApplicationMusicPlayer.shared.queue = [station];
                break;
            default:
                play = false;
                break;
            }
            if play {
                try await MusicKit.ApplicationMusicPlayer.shared.play()
            }
        }
    }
    
    func isArtist() -> Bool {
        switch recoitem {
        case .artist(_):
            return true
        default:
            return false
        }
    }
    
    var body: some View {
        if appear {
            AsyncImage(
                url: artwork.url(width: 128, height: 128),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 64, maxHeight: 64)
                        .clipShape(isArtist() ? .rect(cornerRadius: 96) : .rect(cornerRadius: 4))
                },
                placeholder: {
                    ProgressView()
                }
            )
            .frame(width: 64, height: 64, alignment: .center)
            .onScrollVisibilityChange(onVischange)
        } else {
            VStack{}.frame(width: 64, height: 64).onScrollVisibilityChange(onVischange)
        }
    }
}
