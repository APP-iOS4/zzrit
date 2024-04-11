//
//  ChatMessageCellView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import SwiftUI

struct ChatMessageCellView: View {
    
    var message: MessageModel
    
    var body: some View {
        HStack {
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
                    Text(message.user)
                        .foregroundStyle(Color.staticGray1)
                    
                    // FIXME: 모델 연동시 이곳은 유저가 작성한 메세지로 변경
                    Text(message.message)
                        .foregroundStyle(Color.staticGray1)
                        .padding(10)
                        .background(Color.staticGray6)
                        .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
                }
                
                Text(message.dateString)
                    .font(.caption2)
                    .foregroundStyle(Color.staticGray2)
            }
        }
    }
}

#Preview {
    ChatMessageCellView(message: MessageViewModel.dummyMessage)
}
