//
//  Header.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import Foundation
import SwiftUI

struct Header: View {
    func colorByPath(reqPath: String) -> Color {
        if PathManager.shared.path == reqPath {
            return Color.foregroundPrimary
        } else {
            return Color.foregroundSecondary
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            HeaderButton(path: "::main",  icon: "house",           name: "Home")
            //            HeaderButton(path: "::search",icon: "magnifyingglass", name: "Search")
            SearchBar()
            //            HeaderButton(path: "::radio", icon: "radio",                 name: "Radio")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        //        .padding(.leading, 6)
        .clipShape(.rect(cornerRadius: 6))
    }
}
