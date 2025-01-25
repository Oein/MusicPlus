//
//  WRouter_device.swift
//  weblikerouter
//
//  Created by oein on 1/26/25.
//

import Foundation

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// FROM https://stackoverflow.com/questions/60021403/how-to-get-height-and-width-of-view-or-screen-in-swiftui

class Device {
    static var screen = Device()
    #if os(watchOS)
    var width: CGFloat = WKInterfaceDevice.current().screenBounds.size.width
    var height: CGFloat = WKInterfaceDevice.current().screenBounds.size.height
    #elseif os(iOS)
    var width: CGFloat = UIScreen.main.bounds.size.width
    var height: CGFloat = UIScreen.main.bounds.size.height
    #elseif os(macOS)
    // You could implement this to force a CGFloat and get the full device screen size width regardless of the window size with .frame.size.width
    var width: CGFloat? = NSScreen.main?.visibleFrame.size.width
    var height: CGFloat? = NSScreen.main?.visibleFrame.size.height
    #endif
}
