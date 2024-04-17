//
//  ChatMessageCellView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import SwiftUI

import ZzritKit

struct ChatMessageCellView: View {
    
    var message: ChattingModel
    var isYou: Bool
    var messageType: ChattingType
    
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
                        // FIXME: 메시지를 보낸 유저의 닉네임으로 변경
                        // FIXME: roomModel의 leaderID와 message.userID 비교해서 isleaderID에 넣기
                        ChatMessageName(userID: message.userID, isleaderID: true)
                        
                        // 상대방 메시지 내용
                        HStack(alignment: .bottom) {
                            switch messageType {
                            case .text:
                                Text(message.message)
                                    .foregroundStyle(Color.staticGray1)
                                    .padding(10)
                                    .background(Color.staticGray6)
                                    .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
                                // TODO: 이미지 button으로 바꾸기
                            case .image:
                                fetchImage(url: message.message)
                                    .padding(10)
                            case .notice:
                                Text("nothing")
                            }
                            // 메시지 보낸 날짜 - 상대방
                            Text(DateService.shared.timeString(time: message.date.toStringHour() + ":" + message.date.toStringMinute()))
                                .font(.caption2)
                                .foregroundStyle(Color.staticGray2)
                        }
                    }
                }
                
            //MARK: - 자신 메세지 뷰 구현
                
            } else {
                HStack(alignment: .bottom) {
                    // 메시지 보낸 날짜 - 나
                    Text(DateService.shared.timeString(time: message.date.toStringHour() + ":" + message.date.toStringMinute()))
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
                            // TODO: 이미지 button으로 바꾸기
                        case .image:
                                fetchImage(url: message.message)
                                .padding(10)
                        case .notice:
                            Text("nothing")
                        }
                    }
                }
            }
        }
    }    
//    fetchImage(url: chat.message)
    // 채팅의 이미지 불러오는 함수
    func fetchImage(url: String) -> some View {
        HStack {
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
                    .frame(width: 100, height: 100)
            }
        }
        .frame(height: 100)
    }
}

//#Preview {
//    ChatMessageCellView(message: MessageViewModel.dummyMessage, isYou: <#Bool#>)
//}
