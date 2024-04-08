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
                    RoomCardView(titleToHStackPadding: 75)
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
