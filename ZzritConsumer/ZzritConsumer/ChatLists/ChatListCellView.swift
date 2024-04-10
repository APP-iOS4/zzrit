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
                        .foregroundStyle(.black)
                    
                    // 현재 채팅방 참여 인원 수
                    Text("8")
                        .foregroundStyle(Color.staticGray3)
                }
                
                // 모임 채팅방 제일 최근 글
                Text("최근 채팅 내용입니다asdfasdfasdfasdfasdfasdfasdfasd")
                    .lineLimit(2)
                    .font(.footnote)
                    .foregroundStyle(Color.staticGray3)
                Spacer()
            }
            
            Spacer()
            
            VStack {
                // 최근 채팅 상대시간으로 표시
                Text("방금")
                    .font(.caption2)
                    .foregroundStyle(Color.staticGray3)
                    .padding(.bottom, 15)
                
                // 아직 메세지를 안봤다면 위 이미지 띄우기
                Image(systemName: "n.circle.fill")
                    .foregroundStyle(Color.pointColor)
            }
            .padding(.leading, 20)
        }
        .frame(height: 55)
    }
}

#Preview {
    ChatListCellView()
}