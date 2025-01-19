//
//  ProgressBar.swift
//  musicplus
//
//  Created by oein on 1/20/25.
//

import SwiftUI
import MusicKit

struct ProgressBar: View {
    @State private var dragOffset: CGFloat = 0 // Tracks the drag position
    @State private var isDragging: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                ZStack(alignment: .center) {
                    VStack{}
                        .frame(width: geo.size.width, height: 6)
                        .background(Color.foregroundTertiary)
                        .clipShape(.rect(cornerRadius: 3))
                    HStack {
                        VStack{}
                            .frame(width: geo.size.width * TimeVar.shared.now / (TimeVar.shared.dur == 0 ? 1234567890 : TimeVar.shared.dur), height: 6)
                            .background(Color.foregroundPrimary)
                            .clipShape(.rect(cornerRadius: 3))
                        Spacer()
                    }
                }.frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                .onChanged { value in
                    isDragging = true
                    TimeVar.shared.dragging = true;
                    // Calculate the new progress based on drag location
                    let newOffset = max(0, min(value.location.x, geo.size.width))
                    dragOffset = newOffset
                    
                    // Update time based on drag position
                    let newTime = (newOffset / geo.size.width) * TimeVar.shared.dur
                    TimeVar.shared.now = newTime
                }
                .onEnded { _ in
                    isDragging = false
                    TimeVar.shared.dragging = false;
                    MusicKit.ApplicationMusicPlayer.shared.playbackTime = TimeVar.shared.now
                }
            )
        }
    }
}
