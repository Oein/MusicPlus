//
//  RecoItem.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import Foundation
import SwiftUI
import MusicKit

struct SearchItem: View {
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
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Artwork
            switch recoitem {
            case .station(let station):
                if station.artwork != nil {
                    SearchItemArtwork(artwork: station.artwork!, recoitem: recoitem)
                }
            case .album(let album):
                if album.artwork != nil {
                    SearchItemArtwork(artwork: album.artwork!, recoitem: recoitem)
                }
            case .artist(let artist):
                if artist.artwork != nil {
                    SearchItemArtwork(artwork: artist.artwork!, recoitem: recoitem)
                }
            case .curator(let curator):
                if curator.artwork != nil {
                    SearchItemArtwork(artwork: curator.artwork!, recoitem: recoitem)
                }
            case .musicVideo(let musicVideo):
                if musicVideo.artwork != nil {
                    SearchItemArtwork(artwork: musicVideo.artwork!, recoitem: recoitem)
                }
            case .playlist(let playlist):
                if playlist.artwork != nil {
                    SearchItemArtwork(artwork: playlist.artwork!, recoitem: recoitem)
                }
            case .radioShow(let radioShow):
                if radioShow.artwork != nil {
                    SearchItemArtwork(artwork: radioShow.artwork!, recoitem: recoitem)
                }
            case .recordLabel(let recordLabel):
                if recordLabel.artwork != nil {
                    SearchItemArtwork(artwork: recordLabel.artwork!, recoitem: recoitem)
                }
            case .song(let song):
                if song.artwork != nil {
                    SearchItemArtwork(artwork: song.artwork!, recoitem: recoitem)
                }
            }
            
            // Title
            Text(getName())
                .truncationMode(.tail)
                .frame(maxWidth: 192, maxHeight: 20, alignment: .topLeading)
            
        }.frame(width: 192, alignment: .topLeading)
    }
}

struct SearchItemArtwork: View {
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
                url: artwork.url(width: 384, height: 384),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 192, maxHeight: 192)
                        .clipShape(isArtist() ? .rect(cornerRadius: 96) : .rect(cornerRadius: 4))
                },
                placeholder: {
                    ProgressView()
                }
            )
            .frame(width: 192, height: 192, alignment: .center)
            .overlay(content: {
                if hovered {
                    Color.black.opacity(0.4).clipShape(.rect(cornerRadius: 4))
                }
            })
            .overlay(alignment: .bottomLeading, content: {
                if recoitem.canBePlayed() && hovered {
                    Button(action: play_self, label: {
                        Image(systemName: "play.fill").padding(8)
                            .contentShape(Circle())
                    })
                    .buttonStyle(.plain)
                    .background(hoveredPlayBTN ? Color.servicePrimary : Color.black.opacity(0.2))
                    .clipShape(.circle)
                    .padding(8)
                    .onHover(perform: onHovPlay)
                }
            })
            .onHover(perform: onHov)
            .onTapGesture(perform: {
                switch recoitem {
                case .album(let album):
                    WPath.shared.goto(path: "::album", qparm: album.id.rawValue)
                    break;
                case .artist(let artist):
                    WPath.shared.goto(path: "::artist", qparm: artist.id.rawValue)
                    break;
                case .curator(_):
                    print("Pressed a curator")
                    break;
                case .musicVideo(_):
                    print("Pressed a musicvideo")
                    break;
                case .playlist(let playlist):
                    WPath.shared.goto(path: "::playlist", qparm: playlist.id.rawValue)
                    break;
                case .radioShow(_):
                    print("Pressed a radio show")
                    break;
                case .recordLabel(_):
                    print("Pressed a recordLabel")
                    break;
                case .song(_):
                    play_self()
                    break;
                case .station(let station):
                    WPath.shared.goto(path: "::station", qparm: station.id.rawValue)
                    break;
                }
            })
            .onScrollVisibilityChange(onVischange)
        } else {
            VStack{}.frame(width: 192, height: 192).onScrollVisibilityChange(onVischange)
        }
    }
}
