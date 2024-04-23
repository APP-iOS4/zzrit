//
//  SearchFieldView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

struct SearchFieldView: View {
    // 검색 텍스트
    @State private var searchText: String = ""
    
    var body: some View {
        HStack(spacing: 15.0) {
            TextField("검색어를 입력하세요.", text: $searchText)
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Label("검색 취소", systemImage: "xmark.circle.fill")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(Color.black)
                }
            }
            
            Button {
                Configs.printDebugMessage("검색했습니다.")
            } label: {
                Label("검색", systemImage: "magnifyingglass")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(Color.black)
            }
        }
        .padding()
        
        Divider()
    }
}

#Preview {
    SearchFieldView()
}
