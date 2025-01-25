//
//  MusicAny.swift
//  musicplus
//
//  Created by oein on 1/25/25.
//

import Foundation
import SwiftUI
import MusicKit

enum MusicItemAny {
    case album(Album)
    case artist(Artist)
    case curator(Curator)
    case musicVideo(MusicVideo)
    case playlist(Playlist)
    case radioShow(RadioShow)
    case recordLabel(RecordLabel)
    case song(Song)
    case station(Station)
    
    func canBePlayed() -> Bool {
        switch self {
        case .song:
            return true
        case .album:
            return true
        case .playlist:
            return true
        case .station:
            return true
        default:
            return false
        }
    }
}
