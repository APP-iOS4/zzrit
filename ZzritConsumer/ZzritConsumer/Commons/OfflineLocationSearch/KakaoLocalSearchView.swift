//
//  KakaoLocalSearchView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/20/24.
//

import SwiftUI

struct KakaoLocalSearchView: View {
    @State private var keyword: String = ""
    var body: some View {
        VStack(spacing: 0) {

            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.staticGray5)
        }
        ScrollView {
            
        }
        .navigationTitle("위치 검색")
        .toolbarRole(.editor)
    }
}

#Preview {
    KakaoLocalSearchView()
}
