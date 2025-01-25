//
//  WRouter_NotFound.swift
//  weblikerouter
//
//  Created by oein on 1/26/25.
//

import Foundation
import SwiftUI

struct WRouter_NotFound: View {
    #if os(iOS)
    var bgcl = UIColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 1.0);
    #else
    var bgcl = NSColor(red: 32/255, green: 32/255, blue: 32/255, alpha: 1.0);
    #endif
    var body: some View {
        VStack(alignment: .leading) {
            Text("Not Found")
                .font(.system(size: 28))
                .bold()
            HStack {
                Group {
                    Text("The requested page")
                    HStack {
                        Text(WPath.shared.path)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                    }
                    .background(Color(
                        bgcl
                    ))
                    .foregroundStyle(Color.white)
                    .font(.system(size: 14))
                    .bold()
                    Text("is not found")
                }
            }
            HStack(spacing: 8) {
                Button(action: {
                    WPath.shared.goto(path: "::blank", qparm: nil)
                }) {
                    Text("Go to main page")
                }
                
                Button(action: {
                    WPath.shared.backward()
                }) {
                    Text("Go back")
                }
            }
        }.padding(8)
    }
}
