//
//  RecoItem.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import Foundation
import SwiftUI
import MusicKit

struct RecoItem: View {
    var recoitem: MusicPersonalRecommendation.Item;
    
    @State var hovered = false;
    @State var hoveredPlayBTN = false;
    
    func onHov(hovVal: Bool) {
        hovered = hovVal;
    }
    
    func onHovPlay(hovVal: Bool) {
        hoveredPlayBTN = hovVal;
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(
                url: recoitem.artwork!.url(width: 384, height: 384),
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 192, maxHeight: 192)
                        .clipShape(.rect(cornerRadius: 4))
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
                if hovered {
                    Button(action: {
                        Task {
                            switch recoitem {
                            case .album(let album):
                                MusicKit.ApplicationMusicPlayer.shared.queue = [album];
                                break;
                            case .playlist(let playlist):
                                MusicKit.ApplicationMusicPlayer.shared.queue = [playlist];
                                break;
                            case .station(let station):
                                MusicKit.ApplicationMusicPlayer.shared.queue = [station];
                                break;
                            @unknown default:
                                break;
                            }
                            
                            try await MusicKit.ApplicationMusicPlayer.shared.play()
                        }
                    }, label: {
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
            
            Text(recoitem.title)
                .truncationMode(.tail)
                .frame(maxWidth: 192, maxHeight: 20, alignment: .topLeading)
        }.frame(width: 192, alignment: .topLeading)
    }
}
