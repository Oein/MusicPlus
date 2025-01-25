//
//  Catalog.swift
//  musicplus
//
//  Created by oein on 1/25/25.
//

import SwiftUI
import MusicKit

struct Catalog: View {
    @State var catalog: MusicCatalogSearchResponse? = nil;
    var body: some View {
        VStack(alignment: .leading) {
            if catalog!.topResults.count > 0 {
                Text(catalog!.topResults.title ?? "Top results")
                    .font(.satoshiBold28)
                SearchResults(results: catalog!.topResults.compactMap {
                    switch $0 {
                    case .album(let album):
                        return MusicItemAny.album(album);
                    case .artist(let artist):
                        return MusicItemAny.artist(artist);
                    case .curator(let curator):
                        return MusicItemAny.curator(curator);
                    case .musicVideo(let musicVideo):
                        return MusicItemAny.musicVideo(musicVideo);
                    case .playlist(let playlist):
                        return MusicItemAny.playlist(playlist);
                    case .radioShow(let radioShow):
                        return MusicItemAny.radioShow(radioShow);
                    case .recordLabel(let recordLabel):
                        return MusicItemAny.recordLabel(recordLabel);
                    case .song(let song):
                        return MusicItemAny.song(song);
                    case .station(let station):
                        return MusicItemAny.station(station);
                    default:
                        return nil;
                    }
                })
                .frame(maxWidth: .infinity)
                SPCE()
            }
            
            if catalog!.artists.count > 0 {
                Text(catalog!.artists.title ?? "Artists")
                    .font(.satoshiBold28)
                SearchResults(results: catalog!.artists.compactMap {
                    return .artist($0)
                })
                .frame(maxWidth: .infinity)
                SPCE()
            }
            
            if catalog!.albums.count > 0 {
                Text(catalog!.albums.title ?? "Albums")
                    .font(.satoshiBold28)
                SearchResults(results: catalog!.albums.compactMap {
                    return .album($0)
                })
                .frame(maxWidth: .infinity)
                SPCE()
            }
            
            if catalog!.songs.count > 0 {
                Text(catalog!.songs.title ?? "Songs")
                    .font(.satoshiBold28)
                SearchResults(results: catalog!.songs.compactMap {
                    return .song($0)
                })
                .frame(maxWidth: .infinity)
                SPCE()
            }
            
            if catalog!.stations.count > 0 {
                Text(catalog!.stations.title ?? "Stations")
                    .font(.satoshiBold28)
                SearchResults(results: catalog!.stations.compactMap {
                    return .station($0)
                })
                .frame(maxWidth: .infinity)
                SPCE()
            }
            
            if catalog!.playlists.count > 0 {
                Text(catalog!.playlists.title ?? "Playlists")
                    .font(.satoshiBold28)
                SearchResults(results: catalog!.playlists.compactMap {
                    return .playlist($0)
                })
                .frame(maxWidth: .infinity)
            }
        }
        .padding(8)
        .frame(alignment: .topLeading)
    }
}
