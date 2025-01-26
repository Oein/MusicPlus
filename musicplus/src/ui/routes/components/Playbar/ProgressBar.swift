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
    @State private var startTiming: TimeInterval = 0;
    @State var iOS_Width: CGFloat;
    
    func is_iOS() -> Bool {
#if os(iOS)
        return true;
#else
        return false;
#endif
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                ZStack(alignment: .center) {
                    VStack{}
                        .frame(
                            width: is_iOS() ? iOS_Width : geo.size.width
                            ,height: 6)
                        .background(Color.foregroundTertiary)
                        .clipShape(.rect(cornerRadius: 3))
                    HStack {
                        VStack{}
                            .frame(width: (is_iOS() ? iOS_Width : geo.size.width) * TimeVar.shared.now / (TimeVar.shared.dur == 0 ? 1234567890 : TimeVar.shared.dur), height: 6)
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
                        if !isDragging {
                            startTiming = MusicKit.ApplicationMusicPlayer.shared.playbackTime;
                        }
                        isDragging = true
                        TimeVar.shared.dragging = true;
                        
#if os(macOS)
                        // Calculate the new progress based on drag location
                        let newOffset = max(0, min(value.location.x, geo.size.width))
                        dragOffset = newOffset
                        
                        // Update time based on drag position
                        let newTime = (newOffset / geo.size.width) * TimeVar.shared.dur
                        TimeVar.shared.now = newTime
#else
                        var nTime = startTiming + value.translation.width / iOS_Width * TimeVar.shared.dur;
                        nTime = max(nTime, 0)
                        nTime = min(nTime, TimeVar.shared.dur)
                        TimeVar.shared.now = nTime
#endif
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
