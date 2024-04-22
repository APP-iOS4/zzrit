//
//  ChatMessageCellView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import SwiftUI

import ZzritKit

struct ChatMessageCellView: View {
    // 유저 정보 불러옴
    @EnvironmentObject private var userService: UserService
    
    let leaderID: String
    let message: ChattingModel
    let isYou: Bool
    let messageType: ChattingType
    
    @State private var userName = ""
    @State private var loadImage: UIImage?
    
    var body: some View {
        HStack(alignment: .top) {
            
            //MARK: - 상대방 메세지 뷰 구현
            
            if isYou {
                // FIXME: 유저 프로필 이미지로 변경
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color.staticGray3)
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        // FIXME: 메시지를 보낸 유저의 닉네임으로 변경 -> 참가 리스트로 비교해서 맞는 얘 닉넴으로 연결하면 될까욥?
                        // FIXME: roomModel의 leaderID와 message.userID 비교해서 isleaderID에 넣기
                        ChatMessageName(userName: userName, isleaderID: leaderID ==  message.userID)
                        
                        // 상대방 메시지 내용
                        HStack(alignment: .bottom) {
                            switch messageType {
                            case .text:
                                Text(message.message)
                                    .foregroundStyle(Color.staticGray1)
                                    .padding(10)
                                    .background(Color.staticGray6)
                                    .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
                                // TODO: 이미지 button으로 바꾸기 -> 이미지 크게 띄워주기
                            case .image:
                                Button {
                                    print("사진 크게 보여주기")
                                } label: {
                                    fetchImage(image: loadImage)
                                }
                            case .notice:
                                // 여기선 아무것도 안함
                                Text("nothing")
                            }
                            // 메시지 보낸 날짜 - 상대방
                            Text(DateService.shared.timeString(time: DateService.shared.formattedString(date: message.date, format: "HH") + ":" + message.date.toStringMinute()))
                                .font(.caption2)
                                .foregroundStyle(Color.staticGray2)
                        }
                    }
                }
                
                //MARK: - 자신 메세지 뷰 구현
                
            } else {
                HStack(alignment: .bottom) {
                    // 메시지 보낸 날짜 - 나
                    Text(DateService.shared.timeString(time: DateService.shared.formattedString(date: message.date, format: "HH") + ":" + message.date.toStringMinute()))
                        .font(.caption2)
                        .foregroundStyle(Color.staticGray2)
                    
                    // 나의 메시지 내용
                    VStack(alignment: .leading) {
                        
                        switch messageType {
                        case .text:
                            Text(message.message)
                                .foregroundStyle(.white)
                                .padding(10)
                                .background(Color.pointColor)
                                .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
                            // TODO: 이미지 button으로 바꾸기  -> 이미지 크게 띄워주기
                        case .image:
                            fetchImage(image: loadImage)
                        case .notice:
                            // 여기선 아무것도 안함
                            Text("nothing")
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                userName = await findUserName(userID: message.userID)
                if messageType == .image {
                    loadImage = await ImageCacheManager.shared.findImageFromCache(imageURL: message.message)
                }
            }
        }
    }
    
    // 채팅의 이미지 불러오는 함수
    func fetchImage(image: UIImage?) -> some View {
        HStack {
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
            } else {
                ProgressView()
                    .frame(width: 100, height: 100)
            }
        }
        .frame(height: 100)
    }
    
    // 유저 닉네임 불러오기
    // FIXME: 채팅마다 불러오는게 너무 낭비같다 다음에 다른 방법 고안
    func findUserName(userID: String) async -> String {
        do {
            let username = (try await userService.getUserInfo(uid: userID)?.userName)!
            return username
        } catch {
            return "x"
        }
    }
}

#Preview {
    NavigationStack {
        ChatView(roomID: "1Ab05L2UJXVpbYD7qxNc", room: RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "https://picsum.photos/200", isOnline: false, status: .activation, leaderID: "", limitPeople: 8), isActive: true)
            .environmentObject(UserService())
    }
}
