//
//  ChatRoomNoticeView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/12/24.
//

import SwiftUI

struct ChatRoomNoticeView: View {
    let columns: [GridItem] = [GridItem(.flexible(minimum: 85, maximum: 85)), GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading) {
            Text("모임 일자")
                .fontWeight(.bold)
                .foregroundStyle(Color.pointColor)
                .padding(.bottom, 5)
            Text("2024년 05월 04일 19:00")
                .padding(.bottom, 5)
            
            Text("모임 장소")
                .fontWeight(.bold)
                .foregroundStyle(Color.pointColor)
            Text("서울특별시 종로구 종로 17길 바밤바밤뚜두두")
        }
        .font(.footnote)
        .padding(.horizontal, Configs.paddingValue)
    }
}

#Preview {
    ChatRoomNoticeView()
}
