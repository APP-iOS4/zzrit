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
    
    //MARK: - body
    
    var body: some View {
        List (rooms) { room in
            if room.status == .deactivation {
                ZStack {
                    // 리스트로 보여줄 셀을 ZStack으로 감싼다.
                    ChatListCellView(room: room)
                    
                    NavigationLink {
                        // 상세 페이지
                        // FIXME: 아직 채팅창 뷰는 미구현, 구현 되는 대로 뷰와 모델 연동
                        ChatView(isActive: false)
                    } label: {
                        // 여기는 쓰이지 않는다
                    }
                    //NavigationLink라벨을 가려야 Chevron이 없어진다
                    .opacity(0.0)
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    ChatDeactiveListView(rooms: [RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "", isOnline: false, status: .activation, leaderID: "", limitPeople: 8)])
}
