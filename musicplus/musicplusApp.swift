//
//  musicplusApp.swift
//  musicplus
//
//  Created by oein on 1/18/25.
//

import SwiftUI
import SwiftData

@main
struct musicplusApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands(content: {
#if os(macOS)
            CommandMenu("Moving", content: {
                Button("Backward") {
                    WPath.shared.backward()
                }
                .keyboardShortcut(.leftArrow, modifiers: [.command])
                Button("Forward") {
                    WPath.shared.forward()
                }
                .keyboardShortcut(.rightArrow, modifiers: [.command])
            })
#endif
        })
    }
}
