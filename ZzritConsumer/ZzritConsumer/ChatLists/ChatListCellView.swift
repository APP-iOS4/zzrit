//
//  ChatListCellView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/10/24.
//

import SwiftUI

struct ChatListCellView: View {
    var body: some View {
        HStack {
            // 모임 채팅방 썸네일 이미지
            Image(.dummy)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                HStack {
                    // 모임 채팅방 제목
                    Text("수요일에 맥주 한잔 찌그려요~")
                        .fontWeight(.bold)
                    
                    // 현재 채팅방 참여 인원 수
                    Text("8")
                        .foregroundStyle(Color.staticGray3)
                }
                
                // 모임 채팅방 제일 최근 글
                Text("최근 채팅 내용입니다. 안녕하세요 반갑습니다. 채팅 내용은 두 줄까지 부탁드립니다.")
                    .lineLimit(2)
                    .font(.callout)
                    .foregroundStyle(Color.staticGray3)
            }
            
            VStack {
                Text("방금")
                    .font(.caption2)
                    .foregroundStyle(Color.staticGray3)
                
                Image(systemName: "n.circle.fill")
                    .foregroundStyle(Color.pointColor)
            }
        }
    }
}

#Preview {
    ChatListCellView()
}
