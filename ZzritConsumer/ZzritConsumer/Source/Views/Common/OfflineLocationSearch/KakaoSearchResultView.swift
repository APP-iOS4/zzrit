//
//  KakaoSearchResultView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/21/24.
//

import SwiftUI

struct KakaoSearchResultView: View {
    
    private let kakaoService = KakaoSearchService()
    
    let searchType: OfflineLocationSearchType
    
    @Binding var keyword: String
    @Binding var offlineLocation: OfflineLocationModel?
    
    @State private var results: [KakaoSearchDocumentModel] = []
    
    var body: some View {
        if keyword == "" {
            SearchInfoView()
                .toolbar(.hidden, for: .tabBar)
        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(results) { result in
                        OfflineLocationListCell(keyword: keyword, locationModel: result, searchType: searchType, offlineLocation: $offlineLocation)
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
                let tempResults = try await kakaoService.keywordSearch(keyword: keyword)
                if keyword != "", !tempResults.isEmpty {
                    results = tempResults
                } else if keyword == "" {
                    results.removeAll()
                }
            } catch {
                Configs.printDebugMessage("에러: \(error)")
            }
        }
    }
}

#Preview {
    KakaoSearchResultView(searchType: .currentLocation, keyword: .constant(""), offlineLocation: .constant(nil))
}
