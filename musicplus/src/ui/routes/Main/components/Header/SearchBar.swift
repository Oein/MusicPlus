//
//  HeaderButton.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import SwiftUI

struct SearchBar: View {
    @FocusState private var isTextFieldFocused: Bool
    @State private var text: String = ""
    
    var path = "::search";
    var icon = "magnifyingglass";
    var name = "Search";
    
    func colorByPath() -> Color {
        if PathManager.shared.path == path {
            return Color.foregroundPrimary
        } else {
            return Color.foregroundSecondary
        }
    }
    
    func buttonBackground() -> Color {
        return Color.component.opacity(path == PathManager.shared.path ? 1.0 : 0.0)
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image(systemName: icon)
                    .foregroundStyle(colorByPath())
                    .frame(width: 20, height: 20, alignment: .center)
                if PathManager.shared.path == path {
                    TextField("Search", text: $text, onCommit: {
                        if PathManager.shared.queryparm != text {
                            PathManager.shared.replace(path: "::search", qparm: text)
                        }
                    })
                    .textFieldStyle(.plain)
                    .focused($isTextFieldFocused)
                    .onAppear(perform: {
                        isTextFieldFocused = true;
                    })
                    .onSubmit {
                        isTextFieldFocused = false;
                    }
                    .onChange(of: text, {
                        if PathManager.shared.queryparm != text {
                            PathManager.shared.replace(path: "::search", qparm: text)
                        }
                    })
                } else {
                    Text(text == "" ? name : text)
                        .font(.satoshiRegular16)
                        .foregroundStyle(colorByPath())
                }
            }
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 44)
        .background(buttonBackground())
        .clipShape(.rect(cornerRadius: 6))
        .onTapGesture {
            if PathManager.shared.path != path {
                PathManager.shared.goto(path: path, qparm: nil);
            }
        }
    }
}
