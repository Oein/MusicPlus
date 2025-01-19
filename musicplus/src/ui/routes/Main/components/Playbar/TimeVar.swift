//
//  PathManager.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import Foundation
import MusicKit

@Observable class TimeVar {
    static let shared = TimeVar()
    private init() { }
    
    var now: Double = 0.0;
    var dur: Double = 0.0;
    var artworkURL: URL? = nil;
    var songName = "";
    var songArtist = "";
    var dragging = false;
    var timer: Timer? = nil;
}
