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
    
    @State private var results: [KakaoSearchDocumentModel] = []
    
    var body: some View {
        if keyword == "" {
            SearchInfoView()
                .toolbar(.hidden, for: .tabBar)
        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(results) { result in
                        OfflineLocationListCell(locationModel: result, keyword: keyword)
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            
            if #available(iOS 17.0, *) {
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(height: 1)
                    .onChange(of: keyword) { _, newValue in
                        keywordSearch()
                    }
            } else {
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(height: 1)
                    .onChange(of: keyword) { newValue in
                        keywordSearch()
                    }
            }
        }
    }
    
    private func keywordSearch() {
        Task {
            do {
                results = try await kakaoService.keywordSearch(keyword: keyword)
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    KakaoSearchResultView(keyword: .constant(""))
}
