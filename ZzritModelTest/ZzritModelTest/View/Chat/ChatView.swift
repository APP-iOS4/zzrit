//
//  ChatView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import SwiftUI

import ZzritKit

struct ChatView: View {
    @StateObject private var chattingService = ChattingService(roomID: "1Ab05L2UJXVpbYD7qxNc")
    
    // 입력 메세지 변수
    @State private var messageText: String = ""

    // 활성화 여부
    var isActive: Bool
    
    // 현재 접속한 계정의 uid
    var uid: String = "tMecHWbZuyYapCJmmiN9AnP9TeQ2"
    
    var messages: [ChattingModel] {
        chattingService.messages
    }

    var body: some View {
        // 공지사항: 방의 세부 정보
//        ChatRoomNoticeView()
        Divider()
        
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(messages) { message in
                        chatView(chat: message)
                    }
                }
                .padding(.bottom, 100)
            }
            .padding(.vertical, 1)
            
            // 사용자가 메세지 보내는 뷰
            VStack {
                HStack(alignment: .bottom) {
                    Button {
                        
                    } label: {
                        Image(systemName: "photo.badge.plus")
                            .foregroundStyle(.black)
                            .font(.title3)
                            .padding(.bottom, 10)
                    }
                    
                    // 메세지 입력칸
                    HStack(alignment: .bottom) {
                        TextField(isActive ? "메세지를 입력해주세요." : "비활성화된 모임입니다.", text: $messageText, axis: .vertical)
                            .lineLimit(4)
                            .onSubmit {
                                sendMessage()
                            }
                        if !messageText.isEmpty {
                            Button {
                                messageText = ""
                            } label: {
                                Label("검색 취소", systemImage: "xmark.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .font(.title3)
                                    .foregroundStyle(Color.staticGray3)
                            }
                        }
                        Button {
                            
                        } label: {
                            Image(systemName: "paperplane.circle.fill")
                                .font(.title3)
                                .tint(Color.pointColor)
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.staticGray6))
                }
                .disabled(!isActive)
                .padding(.top, 5)
            }
        }
        .padding(.horizontal, 20)
        .onTapGesture {
//            self.endTextEditing()
        }
        .onAppear {
            fetchChatting()
        }
        // FIXME: 모델 연동시 채팅방 제목으로
        .navigationTitle("수요일에 맥주 한잔 찌그려요~")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            // 오른쪽 메뉴창
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        .toolbarRole(.editor)
    }
    
    private func fetchChatting() {
        Task {
            do {
                try await chattingService.fetchChatting()
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    private func sendMessage() {
        do {
            try chattingService.sendMessage(uid: uid, message: messageText, type: .text)
            messageText = ""
        } catch {
            print("에러: \(error)")
        }
    }
    
    @ViewBuilder
    private func chatView(chat: ChattingModel) -> some View {
        var isYou = uid == chat.userID
        switch chat.type {
        case .text:
            VStack(alignment: isYou ? .trailing : .leading) {
                ChatMessageCellView(message: chat, isYou: isYou)
            }
        case .image:
            Text("이미지")
        case .notice:
            Text(chat.message)
                .foregroundStyle(Color.pointColor)
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.lightPointColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    NavigationStack {
        ChatView(isActive: true)
    }
}
