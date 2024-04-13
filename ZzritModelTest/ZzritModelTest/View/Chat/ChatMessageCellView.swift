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
                // FIXME: 모델 연동시 이곳 이미지 유저 프로필 이미지로 변경
                // 이곳에 나중
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color.staticGray3)
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        //FIXME: 모델 연동시 이곳은 유저의 닉네임으로 변경
                        HStack {
                            // TODO: if userId가 방장 일때
                            Image(systemName: "crown.fill")
                                .font(.callout)
                                .foregroundStyle(Color.yellow)
                            Text(message.userID)
                                .foregroundStyle(Color.staticGray1)
                        }
                        
                        // FIXME: 모델 연동시 이곳은 유저가 작성한 메세지로 변경
                        Text(message.message)
                            .foregroundStyle(Color.staticGray1)
                            .padding(10)
                            .background(Color.staticGray6)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    Text(DateService.shared.formattedString(date: message.date))
                        .font(.caption2)
                        .foregroundStyle(Color.staticGray2)
                }
                
            //MARK: - 자신 메세지 뷰 구현
                
            } else {
                HStack(alignment: .bottom) {
                    // FIXME: 모델 연동시 이곳은 메세지 등록 시간으로 변경
                    Text(DateService.shared.formattedString(date: message.date))
                        .font(.caption2)
                        .foregroundStyle(Color.staticGray2)
                    
                    
                    VStack(alignment: .leading) {
                        // FIXME: 모델 연동시 이곳은 유저가 작성한 메세지로 변경
                        Text(message.message)
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(Color.pointColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }
}
//
//#Preview {
//    ChatMessageCellView(message: MessageViewModel.dummyMessage)
//}
