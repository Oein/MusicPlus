//
//  Main.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//


import SwiftUI

struct LayoutIOSWarp<Content: View>: View {
    let content: Content
    @State var trof: CGFloat = 0;
    @State var mov = false;
    @State var show = false;
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    
    var body: some View {
#if os(iOS)
        ZStack(alignment: .topLeading) {
            content
//            Sidebar()
//                .offset(x: show && !mov ? 0 : (show ? 0 : -196) + trof)
//                .gesture(
//                    DragGesture()
//                        .onChanged({ value in
//                            mov = true;
//                            trof = value.translation.width
//                        })
//                        .onEnded({ value in
//                            mov = false;
//                            if value.translation.width < -80 && show {
//                                show = false;
//                            }
//                            if value.translation.width > 80 && !show {
//                                show = true;
//                            }
//                            trof = 0;
//                        })
//                )
        }
#else
        content
#endif
    }
}

struct Layout<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { _geo in
//            LayoutIOSWarp{
                HStack {
#if os(macOS)
                    Sidebar()
#endif
                    VStack(alignment: .leading) {
                        Header()
                        VStack {
                            ScrollView {
                                content
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .clipShape(.rect(cornerRadius: 6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6) // Rounded border
                                    .stroke(.backgroundSecondary, lineWidth: 1) // Border color and width
                            )
                            Spacer(
                                minLength: 0
                            )
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
#if os(iOS)
                        ScrollView(.horizontal) {
                            Playbar()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 80)
                        .background(Color("Playbar"))
                        .clipShape(.rect(cornerRadius: 6))
#else
                        Playbar()
                            .frame(maxWidth: .infinity, alignment: .leading)
#endif
                    }.frame(maxWidth: .infinity)
                }
//            }
        }
        .padding(8)
    }
}
