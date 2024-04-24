//
//  ChatDeactiveListView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/10/24.
//

import SwiftUI

import ZzritKit

struct ChatDeactiveListView: View {
    let rooms: [RoomModel]
    
    @State private var isActive: Bool = false
    
    //MARK: - body
    
    var body: some View {
        List (rooms) { room in
            if room.status == .deactivation {
                ZStack {
                    // 리스트로 보여줄 셀을 ZStack으로 감싼다.
                    if let roomId = room.id {
                        ChatListCellView(roomID: roomId, room: room)
                        
                        NavigationLink {
                            // 상세 페이지
                            ChatView(roomID: roomId, room: room, isActive: $isActive)
                        } label: {
                            // 여기는 쓰이지 않는다
                        }
                        //NavigationLink라벨을 가려야 Chevron이 없어진다
                        .opacity(0.0)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    ChatDeactiveListView(rooms: [RoomModel(id: "", title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "", isOnline: false, status: .activation, leaderID: "", limitPeople: 8)])
}
