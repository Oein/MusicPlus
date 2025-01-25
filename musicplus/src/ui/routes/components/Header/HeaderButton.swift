//
//  HeaderButton.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import SwiftUI

struct HeaderButton: View {
    var path: String;
    var icon: String;
    var name: String;
    
    func colorByPath() -> Color {
        if WPath.shared.path == path {
            return Color.foregroundPrimary
        } else {
            return Color.foregroundSecondary
        }
    }
    
    func buttonBackground() -> Color {
        return Color.component.opacity(path == WPath.shared.path ? 1.0 : 0.0)
    }
    
    var body: some View {
        VStack {
            Button(action: {
                if WPath.shared.path != path {
                    WPath.shared.goto(path: path, qparm: nil);
                }
            }) {
                HStack(alignment: .center) {
                    Image(systemName: icon)
                        .foregroundStyle(colorByPath())
                        .frame(width: 20, height: 20, alignment: .center)
                    Text(name)
                        .font(.satoshiRegular16)
                        .foregroundStyle(colorByPath())
                }
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
        }
        .frame(width: 140, height: 44)
        .background(buttonBackground())
        .clipShape(.rect(cornerRadius: 6))
    }
}
