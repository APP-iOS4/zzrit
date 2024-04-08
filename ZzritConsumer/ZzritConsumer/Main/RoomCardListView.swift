//
//  RoomCardListView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/8/24.
//

import SwiftUI

struct RoomCardListView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach (1...4, id: \.self) { _ in
                    // 네비게이션 링크를 통한 카드 뷰 상세 페이지 이동
                    NavigationLink {
                        // 상세페이지 뷰 연결
                        Text("상세페이지 뷰")
                    } label: {
                        RoomCardView(titleToHStackPadding: 75)
                    }
                }
                .padding(.trailing, 5)
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 30)
    }
}

#Preview {
    RoomCardListView()
}
