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
    @EnvironmentObject private var lastChatModel: LastChatModel
    
    let roomService = RoomService.shared
   
    let room: RoomModel
    
    @State private var participants: [JoinedUserModel] = []
    @State private var participantsCount: Int = 0
    @State private var roomImage: UIImage?
        
    private var lastMessageDateToCompare: Int? {
        // 활성화 상태일때만 계산
        if room.status == .activation {
            return Int((chattingService.messages.last?.date.timeIntervalSince1970 ?? 0) * 1000)
        } else {
            return nil
        }
    }
    
    private var messageDateString: String {
        return relativeString(chattingService.messages.last?.date ?? Date())
    }
    
    init(roomID: String, room: RoomModel) {
        self._chattingService = StateObject(wrappedValue: ChattingService(roomID: roomID))
        self.room = room
    }
    var latestMessage: String {
        if let lastmessage = chattingService.messages.last {
            switch lastmessage.type {
            case .text:
                return lastmessage.message
            case .image:
                return "사진"
            case .notice:
                let messageParse = lastmessage.message.split(separator: "_")
                if messageParse[1] == "입장" {
                    return "찌릿! 누군가 " + messageParse[1] + "하셨습니다."
                } else {
                    return "어머.. 누군가 " + messageParse[1] + "하셨습니다."
                }
            }
        } else {
            return " "
        }
    }
    
    var body: some View {
        HStack {
            // 모임 채팅방 썸네일 이미지
            fetchRoomImage(image: roomImage)
                .frame(width: 56, height: 56)
            
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
                Text(latestMessage)
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
                }
                
                if room.status == .activation {
                    if lastChatModel.lastChatDates[room.id!] != lastMessageDateToCompare {
                        Image(systemName: "n.circle.fill")
                            .foregroundStyle(Color.pointColor)
                    }
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
                    
                    // 모임방 사진 가져오기
                    if room.coverImage != "NONE" {
                        roomImage = await ImageCacheManager.shared.findImageFromCache(imagePath: room.coverImage)
                    }
                    
                    participantsCount = participants.count
                    fetchChatting()
                } catch {
                    Configs.printDebugMessage("\(error)")
                }
            }
        }
    }
    
    private func fetchChatting() {
        Task {
            do {
                try await chattingService.fetchChatting()
            } catch {
                Configs.printDebugMessage("메세지 셀 에러: \(error)")
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
    
    func fetchRoomImage(image: UIImage?) -> some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .aspectRatio(contentMode: .fill)
            } else {
                // 이미지가 없거나 로드에 실패했을때
                Image("ZziritLogoImage")
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 56, height: 56)
            }
        }
    }
}

#Preview {
    ChatListCellView(roomID: "1Ab05L2UJXVpbYD7qxNc", room: RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "", isOnline: false, status: .activation, leaderID: "", limitPeople: 8))
}
