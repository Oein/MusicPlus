//
//  Main.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import SwiftUI
import MusicKit

struct MainPage: View {
    @State var fetching = false;
    @State var trycnt = 0;
    @State var reco: MusicItemCollection<MusicPersonalRecommendation>? = nil;
    var body: some View {
        Layout {
            ScrollView {
                if reco != nil {
                    VStack(alignment: .leading) {
                        ForEach(reco!, id: \.self) { recoset in
                            RecoSet(recoset: recoset)
                        }
                    }
                } else if fetching {
                    Text("Fetching... Tried " + String(trycnt) + " times.")
                } else {
                    Text("Failed to load.")
                    Button(action: fetch) {
                        Text("Try again")
                    }.buttonStyle(.plain)
                }
            }.padding(8).onAppear(perform: fetch)
        }
    }
    
    func fetch() {
        Task {
            if fetching == true {
                return;
            }
            
            fetching = true;
            trycnt = 0;
            
            while fetching && trycnt < 3 {
                let res = await MusicKitManager.shared.getRecommend();
                switch res {
                case .failure:
                    trycnt += 1;
                    break;
                case .success(let data):
                    fetching = false;
                    reco = data;
                    break;
                }
            }
            
            fetching = false;
        }
    }
}

#Preview {
    MainPage()
}
