//
//  IconButton.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import Foundation
import SwiftUI

struct IconButton: View {
    @State var hovered = false;
    
    let action: () -> Void;
    var icon: String;
    var size: CGFloat = 16;
    
    func onHov(hov: Bool) {
        hovered = hov;
    }
    
    func colorByHov() -> Color {
        if hovered {
            return Color.foregroundPrimary
        }
        return Color.foregroundSecondary
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size))
                .foregroundStyle(colorByHov())
                .frame(width: 24, height: 24, alignment: .center)
        }
        .buttonStyle(.plain)
        .onHover(perform: onHov)
    }
}
