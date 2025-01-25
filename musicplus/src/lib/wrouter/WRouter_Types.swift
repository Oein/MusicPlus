//
//  WRouter_URL.swift
//  weblikerouter
//
//  Created by oein on 1/26/25.
//

import Foundation

struct WRouter_URL {
    var path: String;
    var qparm: String;
}

enum WRouter_GestureType {
    case none
    case backward
    case forward
    case detecting
}
