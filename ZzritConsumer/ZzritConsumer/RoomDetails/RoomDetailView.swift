//
//  RoomDetailView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct RoomDetailView: View {
    let room: RoomModel
    let roomService = RoomService.shared
    // 참석 버튼 눌렀는 지 확인
    @State private var isParticipant: Bool = false
    
    @State private var participants: [JoinedUserModel] = []
    
    @State private var participantsCount: Int = 0
    
    // MARK: - body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    // 상단 타이틀 Stack
                    HStack {
                        // 카테고리
                        RoomCategoryView(room.category.rawValue)
                        
                        // 타이틀
                        Text(room.title)
                            .font(.title3)
                    }
                    
                    // 썸네일 이미지
                    AsyncImage(url: room.roomImage) { image in
                            image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
                            .padding(.bottom, 20)
                        } placeholder: {
                            ProgressView()
                        }
                    // 세부 내용
                    Text(room.content)
                        .foregroundStyle(Color.staticGray1)
                        .padding(.bottom, 40)
                    
                    // 위치, 시간, 참여 인원에 대한 정보를 나타내는 뷰
                    RoomInfoView(room: room, participantsCount: participantsCount)
                        .padding(.bottom, 40)
                    
                    Text("와우, 벌써 \(participantsCount)명이나 모였어요.")
                        .font(.title3)
                        .fontWeight(.bold)
                    // 참여자의 정보를 나타내는 뷰
                    ParticipantListView(room: room, participants: participants)
                }
                .padding(.horizontal, 20)
            }
            .padding(.vertical, 1)
            .padding(.bottom, 85)
            
            VStack {
                GeneralButton("참여하기") {
                    isParticipant.toggle()
                }
                .padding(20)
                .navigationDestination(isPresented: $isParticipant) {
                    ParticipantNoticeView(room: room)
                }
            }
        }
        .toolbarRole(.editor)
        .onAppear {
            Task {
                do {
                    participants = try await roomService.joinedUsers(roomID: room.id ?? "")
                    participantsCount = participants.count
                } catch {
                    print("\(error)")
                }
            }
        }
    }
}

#Preview {
    RoomDetailView(room: RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "https://picsum.photos/200", isOnline: false, status: .activation, leaderID: "", limitPeople: 8))
}
