//
//  OfflineLocationSearchView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import SwiftUI

struct OfflineLocationSearchTextFieldView: View {
    @State private var searchText: String = ""
    
    @Binding var offlineLocationString: String
    
    var body: some View {
        // 검색 필드 뷰
        HStack(spacing: 15.0) {
            TextField("검색어를 입력하세요.", text: $searchText)
                .tint(Color.pointColor)
            
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
                offlineLocationString = searchText
                print("검색했습니다.")
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
    OfflineLocationSearchTextFieldView(offlineLocationString: .constant("서울특별시 종로구"))
}
