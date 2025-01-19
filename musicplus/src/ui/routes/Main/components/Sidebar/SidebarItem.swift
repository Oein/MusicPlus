//
//  SidebarItem.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import SwiftUI

struct SidebarItem: View {
    var iconname: String;
    var content: String;
    var path: String;
    
    var body: some View {
        Button(action: {
            if PathManager.shared.path != path {
                PathManager.shared.goto(path: path, qparm: nil)
            }
        }) {
            VStack {
                HStack(alignment: .center) {
                    Image(systemName: iconname)
                        .foregroundColor(Color("Foreground-Secondary"))
                        .frame(width: 20, height: 20, alignment: .center)
                    Text(content)
                        .foregroundStyle(Color("Foreground-Secondary"))
                        .font(.satoshiRegular14)
                }
                .padding(.all, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .greatestFiniteMagnitude, alignment: .leading)
        }
        .buttonStyle(.plain)
    }
}
