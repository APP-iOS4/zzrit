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
    
    @State private var fullAddress: String = ""
    
    var locationString: String {
        if let platformName = room.platform?.rawValue {
            return platformName
        } else {
            return "\(fullAddress) \(room.placeName ?? "")"
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: Configs.paddingValue) {
            VStack(spacing: 5) {
                Text("모임 일자")
                Text("모임 장소")
            }
            .fontWeight(.bold)
            .foregroundStyle(Color.pointColor)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(DateService.shared.formattedString(date: room.dateTime))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(locationString)")
                
            }
        }
        .font(.footnote)
        .padding(.horizontal, Configs.paddingValue)
        .padding(.vertical, 10)
        .task {
            fullAddress = await room.fullAddress() ?? ""
        }
    }
}

#Preview {
    ChatRoomNoticeView(room: RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "https://picsum.photos/200", isOnline: false, status: .activation, leaderID: "", limitPeople: 8, scoreLimitaion: 40, genderLimitation: .female))
}
