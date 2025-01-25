//
//  ContentView.swift
//  musicplus
//
//  Created by oein on 1/18/25.
//

import SwiftUI
import SwiftData

import Foundation

struct ContentView: View {
    
    var body: some View {
        WRouterView { url, _ in
            switch url {
            case "::blank":
                PreloadPage()
            case "::auth":
                AuthPage()
            case "::main":
                MainPage()
            case "::search":
                Search()
            case "::lib-reccent":
                ReccentlyAdded()
            case "::lib-song":
                LibSong()
            case "::lib-artist":
                LibArtist()
            case "::lib-album":
                LibAlbum()
            case "::artist":
                CatArtist()
            case "::playlist":
                CatPlaylist()
            case "::album":
                CatAlbum()
            default:
                NotFound()
            }
        }
            .colorScheme(.dark)
            .foregroundStyle(Color("Foreground-Primary"))
            .font(.satoshiMedium16)
    }
}

#Preview {
    ContentView()
}
