//
//  Global.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import SwiftUI

struct Router: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color("Background-Main").edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    switch PathManager.shared.path {
                    case "::blank":
                        PreloadPage()
                    case "::auth":
                        AuthPage()
                    case "::main":
                        MainPage()
                    case "::search":
                        Search()
                    case "::lib-reccent":
                        ReccentlyAdded()
                    case "::lib-song":
                        LibSong()
                    default:
                        NotFound()
                    }
                }
                .frame(maxWidth:.infinity,maxHeight:.infinity,alignment:.topLeading)
            }
            .foregroundStyle(Color("Foreground-Primary"))
            .frame(
                maxWidth:.infinity,maxHeight:.infinity,alignment:.topLeading
            )
            .font(.satoshiMedium16)
        }
    }
}
