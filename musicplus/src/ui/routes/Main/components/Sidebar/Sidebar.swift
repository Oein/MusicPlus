//
//  Header.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import Foundation
import SwiftUI

struct Sidebar: View {
    var show: Bool;
    var body: some View {
        VStack {
            VStack {
                HStack(alignment: .center) {
                    Image(systemName: "books.vertical")
                        .foregroundStyle(Color("Foreground-Secondary"))
                        .frame(width: 20, height: 20, alignment: .center)
                    Text("My Library")
                        .font(.satoshiRegular16)
                        .foregroundStyle(Color("Foreground-Secondary"))
                }
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            }.frame(height: 44)
            
            ScrollView {
                SidebarItem(iconname: "clock", content: "Reccently added", path: "::lib-reccent")
                SidebarItem(iconname: "music.note", content: "Songs", path: "::lib-song")
                SidebarItem(iconname: "music.microphone", content: "Artists", path: "::lib-artist")
                SidebarItem(iconname: "square.stack", content: "Album", path: "::lib-album")
            }.frame(maxHeight: .infinity)
            
            Spacer()
        }
        .frame(maxHeight: .infinity, alignment: .leading)
        .frame(width: show ? 180 : 6, alignment: .leading)
        .padding(.leading, 6)
        .background(Color.component)
        .clipShape(.rect(cornerRadius: 6))
    }
}
