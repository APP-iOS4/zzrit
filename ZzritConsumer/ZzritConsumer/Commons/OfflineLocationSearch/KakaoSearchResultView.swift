//
//  KakaoSearchResultView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/21/24.
//

import SwiftUI

struct KakaoSearchResultView: View {
    private let kakaoService = KakaoSearchService()
    
    @Binding var keyword: String
    
    @State private var results = ""
    
    var body: some View {
        if keyword == "" {
            SearchInfoView()
        } else {
            Text("검색중")
        }
    }
    
    init(keyword: Binding<String>) {
        self._keyword = keyword
        keywordSearch()
    }
    
    private func keywordSearch() {
        Task {
            do {
                try await kakaoService.keywordSearch(keyword: keyword)
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    KakaoSearchResultView(keyword: .constant(""))
}
