//
//  ChatRoomNoticeView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/12/24.
//

import SwiftUI

import ZzritKit

struct ChatRoomNoticeView: View {
    let room: RoomModel
    
    let columns: [GridItem] = [GridItem(.flexible(minimum: 85, maximum: 85)), GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading) {
            Text("모임 일자")
                .fontWeight(.bold)
                .foregroundStyle(Color.pointColor)
                .padding(.bottom, 5)
            Text(DateService.shared.formattedString(date: room.dateTime))
                .padding(.bottom, 5)
            
            Text("모임 장소")
                .fontWeight(.bold)
                .foregroundStyle(Color.pointColor)
            // FIXME: RoomModel.placeLatitude - RoomModel.placeLongitude
            Text("서울특별시 종로구 종로 17길 바밤바밤뚜두두")
        }
        .font(.footnote)
        .padding(.horizontal, Configs.paddingValue)
        .padding(.vertical, Configs.paddingValue)
    }
}

#Preview {
    ChatRoomNoticeView(room: RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "https://picsum.photos/200", isOnline: false, status: .activation, leaderID: "", limitPeople: 8))
}
