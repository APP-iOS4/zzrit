//
//  ChatListCellView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/10/24.
//

import SwiftUI

import ZzritKit

struct ChatListCellView: View {
    @StateObject private var chattingService: ChattingService
    
    let roomService = RoomService.shared
    let room: RoomModel
    
    @State private var participants: [JoinedUserModel] = []
    @State private var participantsCount: Int = 0
    
    private var messageDateString: String {
        return relativeString(chattingService.messages.last?.date ?? Date())
    }
    
    init(roomID: String, room: RoomModel) {
        self._chattingService = StateObject(wrappedValue: ChattingService(roomID: roomID))
        self.room = room
    }
    
    var body: some View {
        HStack {
            // 모임 채팅방 썸네일 이미지
            AsyncImage(url: room.roomImage) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading) {
                HStack {
                    // 모임 채팅방 제목
                    Text(room.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                    
                    // 현재 채팅방 참여 인원 수
                    Text("\(participantsCount)")
                        .foregroundStyle(Color.staticGray3)
                }
                
                // 모임 채팅방 제일 최근 글
                Text(chattingService.messages.last?.message ?? "메세지가 없습니다.")
                    .lineLimit(2)
                    .font(.footnote)
                    .foregroundStyle(Color.staticGray3)
                Spacer()
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                // 최근 채팅 상대시간으로 표시
                if chattingService.messages.last != nil {
                    Text(messageDateString)
                        .font(.caption2)
                        .foregroundStyle(Color.staticGray3)
                        .padding(.bottom, 15)
                    
                    // 아직 메세지를 안봤다면 위 이미지 띄우기
                    Image(systemName: "n.circle.fill")
                        .foregroundStyle(Color.pointColor)
                }
            }
            .padding(.leading, 20)
        }
        .frame(height: 55)
        .onAppear {
            Task {
                do {
                    if let roomId = room.id {
                        participants = try await roomService.joinedUsers(roomID: roomId)
                    }
                    participantsCount = participants.count
                    fetchChatting()
                } catch {
                    print("\(error)")
                }
            }
        }
    }
    
    private func fetchChatting() {
        Task {
            do {
                try await chattingService.fetchChatting()
            } catch {
                print("메세지 셀 에러: \(error)")
            }
        }
    }
    
    private func relativeString(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateTimeStyle = .named
        formatter.unitsStyle = .short
        let dateToString = formatter.localizedString(for: date, relativeTo: .now)
        return dateToString.hasSuffix("초 전") ? "방금" : dateToString
    }
}

#Preview {
    ChatListCellView(roomID: "1Ab05L2UJXVpbYD7qxNc", room: RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "", isOnline: false, status: .activation, leaderID: "", limitPeople: 8))
}
