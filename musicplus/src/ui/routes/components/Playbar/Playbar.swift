//
//  Header.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import Foundation
import SwiftUI
import MusicKit
import CoreMedia

struct Playbar: View {
    @ObservedObject private var state = ApplicationMusicPlayer.shared.state
    
    func playPaus() {
        switch MusicKit.ApplicationMusicPlayer.shared.state.playbackStatus {
        case .playing:
            MusicKit.ApplicationMusicPlayer.shared.pause()
        default:
            Task {
                try await MusicKit.ApplicationMusicPlayer.shared.play()
            }
        }
    }
    
    func backward() {
        Task {
            try await MusicKit.ApplicationMusicPlayer.shared.skipToPreviousEntry()
        }
    }
    
    func forward() {
        Task {
            try await MusicKit.ApplicationMusicPlayer.shared.skipToNextEntry()
        }
    }
    
    func shuffle() {
        if state.shuffleMode == nil {
            MusicKit.ApplicationMusicPlayer.shared.state.shuffleMode = .songs;
        } else if state.shuffleMode == .off {
            MusicKit.ApplicationMusicPlayer.shared.state.shuffleMode = .songs;
        } else if state.shuffleMode == .songs {
            MusicKit.ApplicationMusicPlayer.shared.state.shuffleMode = .off;
        }
    }
    
    func repea_t() {
        if state.repeatMode == nil {
            MusicKit.ApplicationMusicPlayer.shared.state.repeatMode = .one;
        } else if state.repeatMode == MusicPlayer.RepeatMode.none {
            MusicKit.ApplicationMusicPlayer.shared.state.repeatMode = .one;
        } else if state.repeatMode == .one {
            MusicKit.ApplicationMusicPlayer.shared.state.repeatMode = .all;
        } else if state.repeatMode == .all {
            MusicKit.ApplicationMusicPlayer.shared.state.repeatMode = nil;
        }
    }
    
    func format_time(d: Double) -> String {
        let it = Int(d) as Int
        let min = Int(it / 60);
        let sec = Int(it % 60);
        
        var minst = String(min);
        var secst = String(sec);
        
        if minst.count < 2 {
            minst = "0" + minst;
        }
        if secst.count < 2 {
            secst = "0" + secst;
        }
        
        return minst + ":" + secst
    }
    
    func onAppear() {
        TimeVar.shared.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            if !TimeVar.shared.dragging {
                TimeVar.shared.now = MusicKit.ApplicationMusicPlayer.shared.playbackTime;
            }
            let cent = MusicKit.ApplicationMusicPlayer.shared.queue.currentEntry;
            if cent != nil && cent!.item != nil {
                switch cent!.item! {
                case .song(let song):
                    TimeVar.shared.dur = song.duration ?? 0.0;
                    TimeVar.shared.artworkURL = song.artwork?.url(width: 384, height: 384);
                    TimeVar.shared.songName = song.title;
                    TimeVar.shared.songArtist = song.artistName;
                    break;
                case .musicVideo(let mv):
                    TimeVar.shared.dur = mv.duration ?? 0.0;
                    TimeVar.shared.artworkURL = mv.artwork?.url(width: 384, height: 384);
                    TimeVar.shared.songName = mv.title;
                    TimeVar.shared.songArtist = mv.artistName;
                    break;
                default:
                    TimeVar.shared.dur = 0.0;
                    break;
                }
            } else {
                TimeVar.shared.dur = 0.0;
            }
        })
    }
    
    func onDisappear() {
        TimeVar.shared.timer?.invalidate();
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Button(action: playPaus) {
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
                
                IconButton(action: backward, icon: "backward.end")
                IconButton(action: forward, icon: "forward.end")
                IconButton(action: shuffle, icon: state.shuffleMode == .songs ? "shuffle.circle.fill" : "shuffle", size: state.shuffleMode == .songs ? 28 : 16)
                IconButton(action: repea_t,
                           icon: state.repeatMode == .all ? "repeat.circle.fill" :
                            state.repeatMode == .one ? "repeat.1.circle.fill" : "repeat",
                           size: state.repeatMode == MusicPlayer.RepeatMode.none || state.repeatMode == nil ? 16 : 28
                )
                HStack(alignment: .center) {
                    HStack {
                        Text(format_time(d: TimeVar.shared.now))
                            .font(.satoshiRegular14)
                            .frame(minWidth: 50, alignment: .center)
#if os(iOS)
                        
                        ProgressBar().frame(minWidth: 120)
#else
                        ProgressBar()
#endif
                        Text(format_time(d: TimeVar.shared.dur))
                            .font(.satoshiRegular14)
                            .frame(minWidth: 50, alignment: .center)
                    }.frame(maxWidth: .infinity)
                    
                    HStack(spacing: 16) {
                        if TimeVar.shared.artworkURL != nil {
                            AsyncImage(
                                url: TimeVar.shared.artworkURL!,
                                content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(.rect(cornerRadius: 4))
                                },
                                placeholder: {
                                    ProgressView()
                                }
                            )
                            .frame(maxHeight: .infinity, alignment: .center)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(TimeVar.shared.songName)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                            Text(TimeVar.shared.songArtist)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                                .font(.satoshiRegular14)
                                .foregroundStyle(Color.foregroundSecondary)
                        }.frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        Spacer()
                    }
                }.frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.horizontal, 16)
            .padding(8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 80)
        .background(Color("Playbar"))
        .clipShape(.rect(cornerRadius: 6))
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }
}
