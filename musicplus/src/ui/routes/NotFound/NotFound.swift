//
//  NotFound.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import SwiftUI

struct NotFound: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Not Found")
                .font(.satoshiBold28)
            HStack {
                Group {
                    Text("The requested page")
                    HStack {
                        Text(PathManager.shared.path)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                    }
                    .background(Color("Background-Secondary"))
                    .foregroundStyle(Color.white)
                    .font(.satoshiBold14)
                    Text("is not found")
                }
            }
            HStack(spacing: 8) {
                Button(action: {
                    PathManager.shared.goto(path: "::blank", qparm: nil)
                }) {
                    Text("Go to main page")
                }
                
                Button(action: {
                    PathManager.shared.backward()
                }) {
                    Text("Go back")
                }
            }
        }.padding(8)
    }
}

#Preview {
    NotFound ()
}
