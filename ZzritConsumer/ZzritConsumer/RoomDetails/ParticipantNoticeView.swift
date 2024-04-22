//
//  ParticipantNoticeView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ParticipantNoticeView: View {
    @EnvironmentObject private var userService: UserService
    
    // 입장 메시지 입력을 위한 채팅
    @StateObject private var chattingService: ChattingService
    
    private let roomService = RoomService.shared
    
    let room: RoomModel
    // 동의사항 체크했는지
    @State private var isCheck: Bool = false
    // 채팅방 입장 버튼을 눌렀는지
    @State private var isPressedChat: Bool = false
    
    init(room: RoomModel) {
        self._chattingService = StateObject(wrappedValue: ChattingService(roomID: room.id!))
        self.room = room
    }
    
    // MARK: - body
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "exclamationmark.bubble.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25)
                    .foregroundStyle(.red)
                
                Text("잠깐만요!")
                    .font(.title)
                
                Spacer()
            }
            .padding(.bottom, 20)
            
            HStack {
                Text("더욱 즐거운 만남이 될 수 있도록,\n같이 지켜주세요.")
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(.bottom, 20)
            
            HStack {
                VStack {
                    Image(systemName: "1.circle.fill")
                    Spacer()
                }
                Text("만남 전, 참석이 어려울 경우엔\n꼭! 다른 사람들에게 알려주세요.")
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.staticGray1)
                
                Spacer()
            }
            .frame(height: 43)
            .padding(.bottom, 10)
            
            HStack {
                VStack {
                    Image(systemName: "2.circle.fill")
                    Spacer()
                }
                Text("비속어 또는 험담은 자신의 정전기가\n깎일 수 있어요!")
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.staticGray1)
                
                Spacer()
            }
            .frame(height: 43)
            .padding(.bottom, 10)
            
            HStack {
                VStack {
                    Image(systemName: "3.circle.fill")
                    Spacer()
                }
                Text("모임에서 부당한 일을 당했을 경우,\n주저하지 말고 신고해주세요!")
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.staticGray1)
                
                Spacer()
            }
            .frame(height: 43)
            .padding(.bottom, 20)
            
            Spacer()
            
            Button {
                isCheck.toggle()
            } label: {
                HStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(isCheck ? Color.pointColor : Color.staticGray2)
                    Text("위 내용을 확인했으며, 동의 시 채팅방으로 입장합니다.")
                        .font(.caption)
                        .foregroundStyle(Color.staticGray2)
                }
            }
            .padding(.bottom, 10)
            
            GeneralButton("채팅방 입장", isDisabled: !isCheck) {
                joinedRoom()
            }
            .navigationDestination(isPresented: $isPressedChat) {
                if let roomId = room.id {
                    ChatView(roomID: roomId, room: room, isActive: true)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .toolbarRole(.editor)
    }
    
    func joinedRoom() {
        Task {
            try await roomService.joinRoom(room.id ?? "")
            guard let username = try await userService.loginedUserInfo()?.userName else { return }
            try chattingService.sendMessage(message: "\(username)님께서 입장하셨습니다.")
            print("입장하기")
            isPressedChat.toggle()
        }
    }
}

//#Preview {
//    NavigationStack {
//        ParticipantNoticeView(chattingService: ChattingService(roomID: <#T##String#>), room: RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "https://picsum.photos/200", isOnline: false, status: .activation, leaderID: "", limitPeople: 8))
//            .environmentObject(UserService())
//    }
//}
