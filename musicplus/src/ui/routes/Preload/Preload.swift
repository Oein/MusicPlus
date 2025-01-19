//
//  Preload.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import SwiftUI

struct PreloadPage: View {
    var body: some View {
        Text("Loading...").onAppear(perform: {
            if MusicKitManager.shared.hasPermission() {
                PathManager.shared.set_path(path: "::main", qparm: nil)
            } else {
                PathManager.shared.set_path(path: "::auth", qparm: nil)
            }
        })
    }
}
