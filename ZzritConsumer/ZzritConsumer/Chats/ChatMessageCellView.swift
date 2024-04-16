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
    
    var body: some View {
        HStack {
            
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
                        HStack {
                            // TODO: if userId가 방장 일때
                            // if message.userID == RoomModel.leaderID
                            Image(systemName: "crown.fill")
                                .font(.callout)
                                .foregroundStyle(Color.yellow)
                            Text(message.userID)
                                .foregroundStyle(Color.staticGray1)
                        }
                        // 상대방 메시지 내용
                        Text(message.message)
                            .foregroundStyle(Color.staticGray1)
                            .padding(10)
                            .background(Color.staticGray6)
                            .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
                    }
                    // 메시지 보낸 날짜 - 상대방
                    Text(DateService.shared.timeString(time: message.date.toStringHour() + ":" + message.date.toStringMinute()))
                        .font(.caption2)
                        .foregroundStyle(Color.staticGray2)
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
                        Text(message.message)
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(Color.pointColor)
                            .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
                    }
                }
            }
        }
    }
}

//#Preview {
//    ChatMessageCellView(message: MessageViewModel.dummyMessage, isYou: <#Bool#>)
//}
