//
//  Auth.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import SwiftUI

struct AuthPage: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("Welcome back!")
                    .font(.satoshiBold28)
                Button(
                    action: {
                        Task {
                            let res = await MusicKitManager.shared.requestAuth()
                            if res {
                                WPath.shared.set_path(path: "main", qparm: nil)
                            } else {
                                print("TODO:: ALERT - AUTH FAILED")
                            }
                        }
                    },
                    label: {
                        Text("Authorize with Apple Music")
                            .padding(.horizontal, 18)
                            .padding(.vertical, 8)
                    }
                )
                .buttonStyle(.plain)
                .background(Color("Background-Secondary"))
                .clipShape(.buttonBorder)
                Spacer()
            }
            Spacer()
        }
    }
}
