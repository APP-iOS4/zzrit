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
    @State private var userProfileImage: UIImage?
    
    var body: some View {
        HStack(alignment: .top) {
            
            //MARK: - 상대방 메세지 뷰 구현
            
            if isYou {
                // 유저 프로필 이미지
                fetchUserImage(image: userProfileImage)
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
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
                            case .image:
                                fetchChatImage(image: loadImage)
                            case .notice:
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
                        case .image:
                            fetchChatImage(image: loadImage)
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
                // 유저 별명 가져오기
                userName = await findUserName(userID: message.userID)
                // 유저 프로필사진 가져오기
                guard let userImageURL = try await userService.findUserInfo(uid: message.userID)?.userImage else { return }
                userProfileImage =  await ImageCacheManager.shared.findImageFromCache(imageURL: userImageURL)
                if messageType == .image {
                    // 채팅 메시지가 이미지일 경우 불러오기
                    loadImage = await ImageCacheManager.shared.findImageFromCache(imageURL: message.message)
                }
            }
        }
    }
    
    // 채팅의 이미지 불러오는 함수
    func fetchChatImage(image: UIImage?) -> some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
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
    
    // 유저 이미지
    func fetchUserImage(image: UIImage?) -> some View {
        HStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .clipShape(Circle())
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
            } else {
                // 이미지가 없거나 로드에 실패했을때
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color.staticGray3)
            }
        }
    }
    // 유저 닉네임 불러오기
    // FIXME: 채팅마다 불러오는게 너무 낭비같다 다음에 다른 방법 고안
    func findUserName(userID: String) async -> String {
        do {
            let username = (try await userService.findUserInfo(uid: userID)?.userName)!
            return username
        } catch {
            return "x"
        }
    }
}

#Preview {
    NavigationStack {
        ChatView(roomID: "1Ab05L2UJXVpbYD7qxNc", room: RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "https://picsum.photos/200", isOnline: false, status: .activation, leaderID: "", limitPeople: 8), isActive: .constant(true))
            .environmentObject(UserService())
    }
}
