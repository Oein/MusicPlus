//
//  TopResults.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import Foundation
import SwiftUI
import MusicKit

struct SearchResults: View {
    var results: [MusicItemAny];
    var body: some View {
        HStack(alignment: .top) {
            ForEach(Array(results.enumerated()), id: \.offset) { index, item in
                SearchItem(recoitem: item)
            }
        }.frame(maxWidth: .infinity, alignment: .topLeading)
    }
}
