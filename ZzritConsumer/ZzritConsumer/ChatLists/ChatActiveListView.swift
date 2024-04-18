//
//  ChatListView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/10/24.
//

import SwiftUI

import ZzritKit

struct ChatActiveListView: View {
    
    let rooms: [RoomModel]
    
    //MARK: - body
    
    var body: some View {
        List (rooms) { room in
            if room.status == .activation {
                ZStack {
                    // 리스트로 보여줄 셀을 ZStack으로 감싼다.
                    ChatListCellView(roomID: room.id ?? "", room: room)
                    
                    NavigationLink {
                        // 상세 페이지
                        // FIXME: 아직 채팅창 뷰는 미구현, 구현 되는 대로 뷰와 모델 연동
                        ChatView(roomID: room.id ?? "", room: room, isActive: true)
                    } label: {
                        // 여기는 쓰이지 않는다
                    }
                    .opacity(0.0)
                }
            }
        }
        .listStyle(.plain)
    }
}

//MARK: - List 오류 시 ScrollView로 변경
//        ScrollView {
//            LazyVStack {
//                ForEach (0...3, id: \.self) { _ in
//                    NavigationLink {
//                        // 상세 페이지
//                        // FIXME: 아직 채팅창 뷰는 미구현, 구현 되는 대로 뷰와 모델 연동
//                        Text("활성화 된 채팅창 뷰 입니다.")
//                    } label: {
//                        // 리스트에 보여줄 셀들
//                        // FIXME: 모델 연동 시, 모델 받는 것으로 수정해야 함
//                        ChatListCellView()
//                            .padding(.bottom, Configs.paddingValue)
//                    }
//                }
//            }
//        }

#Preview {
    NavigationStack {
        ChatActiveListView(rooms: [RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "", isOnline: false, status: .activation, leaderID: "", limitPeople: 8)])
    }
}
