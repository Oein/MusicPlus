//
//  Results.swift
//  musicplus
//
//  Created by oein on 1/25/25.
//

import Foundation
import SwiftUI

struct SearchResultsView: View {
    var results: [MusicItemAny] = [];
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(Array(results.enumerated()), id: \.offset) { idx, val in
                if results.count > 0 && (idx == max(0, results.count - 10) || idx == results.count - 1) {
                    
                    SearchItemRow(recoitem: val)
                        .frame(maxWidth: .infinity)
                        .onScrollVisibilityChange({ vis in
                            MusicKitManager.shared.requiredsearchmore = MusicKitManager.shared.requiredsearchmore || vis;
                        })
                } else {
                    SearchItemRow(recoitem: val)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(8)
        .frame(alignment: .topLeading)
    }
}
