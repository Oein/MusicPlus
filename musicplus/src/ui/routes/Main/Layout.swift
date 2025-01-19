//
//  Main.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//


import SwiftUI

struct Layout<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { _geo in
            HStack {
                Sidebar()
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
                    Playbar()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.frame(maxWidth: .infinity)
            }
        }
        .padding(8)
    }
}
