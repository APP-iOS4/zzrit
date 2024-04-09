//
//  RecentWatchRoomView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

struct RecentWatchRoomView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("최근 본 모임")
                .font(.title3)
                .fontWeight(.bold)
            VStack {
                //TODO: 리스트 크기 높이 조절
                RoomCardListView()
            }
        }
    }
}

#Preview {
    RecentWatchRoomView()
}
