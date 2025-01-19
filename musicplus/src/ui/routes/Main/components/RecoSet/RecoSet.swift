//
//  RecoSet.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import Foundation
import SwiftUI
import MusicKit

struct RecoSet: View {
    var recoset: MusicPersonalRecommendation;
    var body: some View {
        VStack(alignment: .leading) {
            if recoset.title != nil {
                Text(recoset.title!)
                    .font(.satoshiBold24)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(recoset.items, id: \.self) { recoitem in
                        RecoItem(recoitem: recoitem)
                    }
                }
            }
        }
    }
}
