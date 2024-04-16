//
//  ChatView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import SwiftUI

import ZzritKit

struct ChatView: View {
    // TODO: 모임방의 ID
    @StateObject private var chattingService = ChattingService(roomID: "1Ab05L2UJXVpbYD7qxNc")
    
    // 현재 계정의 uid = tMecHWbZuyYapCJmmiN9AnP9TeQ2
    var uid: String = "tMecHWbZuyYapCJmmiN9AnP9TeQ2"
    
    // 입력 메세지 변수
    @State private var messageText: String = ""
    
    // FIXME: 모임방 활성화 여부
    var isActive: Bool
    
    // 메시지 모델
    var messages: [ChattingModel] {
        chattingService.messages
    }
    
    var body: some View {
        
        // FIXME: 모임의 장소, 시간 정보 View 한번 들어가서 고쳐주세요.
        ChatRoomNoticeView()
        Divider()
        
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    // 채팅 내용 스크롤뷰
                    ForEach(messages) { message in
                        chatView(chat: message)
                    }
                }
            }
            .padding(.vertical, 5)
            .onTapGesture {
                self.endTextEditing()
            }
            .onAppear {
                fetchChatting()
            }
            
            // 사용자가 메세지 보내는 뷰
            VStack {
                HStack(alignment: .bottom) {
                    // 사진 보내기 버튼
                    Button {
                        
                    } label: {
                        Image(systemName: "photo.badge.plus")
                            .foregroundStyle(.black)
                            .font(.title3)
                            .padding(.bottom, 10)
                    }
                
                    HStack(alignment: .bottom) {
                        // 입력칸
                        TextField(isActive ? "메세지를 입력해주세요." : "비활성화된 모임입니다.", text: $messageText, axis: .vertical)
                            .lineLimit(4)
                            .onSubmit {
                                sendMessage()
                            }
                        // 입력칸 지우기 버튼
                        if !messageText.isEmpty {
                            Button {
                                messageText = ""
                            } label: {
                                Label("입력 취소", systemImage: "xmark.circle.fill")
                                    .labelStyle(.iconOnly)
                                    .font(.title3)
                                    .foregroundStyle(Color.staticGray3)
                            }
                        }
                        // 메시지 보내기 버튼
                        Button {
                            sendMessage()
                        } label: {
                            Image(systemName: "paperplane.circle.fill")
                                .font(.title3)
                                .tint(Color.pointColor)
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: Configs.cornerRadius).foregroundStyle(Color.staticGray6))
                }
                .disabled(!isActive)
                .padding(.top, 5)
            }
        }
        .padding(.horizontal, Configs.paddingValue)
        
        // FIXME: 채팅방 제목으로
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
    
    // 채팅 불러오는 함수
    private func fetchChatting() {
        Task {
            do {
                try await chattingService.fetchChatting()
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    // 메세지 보내는 함수
    private func sendMessage() {
        do {
            try chattingService.sendMessage(uid: uid, message: messageText, type: .text)
            messageText = ""
        } catch {
            print("에러: \(error)")
        }
    }
    
    // 메시지 뷰
    @ViewBuilder
    private func chatView(chat: ChattingModel) -> some View {
        let isYou = uid != chat.userID
        switch chat.type {
        case .text:
            HStack {
                if !isYou {
                    Spacer()
                }
                ChatMessageCellView(message: chat, isYou: isYou)
                if isYou {
                    Spacer()
                }
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
