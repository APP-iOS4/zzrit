//
//  ChatView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import SwiftUI

struct ChatView: View {
    // 입력 메세지 변수
    @State private var messageText: String = ""
    // 활성화 여부
    var isActive: Bool
    //임시 뷰모델 호출
    let messageViewModel: MessageViewModel = MessageViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVStack {
                    ForEach(messageViewModel.messages) { message in
                        // 메세지가 상대방일 경우
                        if !message.isYou {
                            LazyVStack(alignment: .leading) {
                                ChatMessageCellView(message: message)
                            }
                        //  메세지가 내꺼일 경우
                        } else {
                            LazyVStack(alignment: .trailing) {
                                ChatMessageCellView(message: message)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 1)
            
            // 사용자가 메세지 보내는 뷰
            VStack {
                Divider()
                
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "photo.badge.plus")
                            .foregroundStyle(.black)
                    }
                    
                    // 메세지 입력칸
                    TextField(isActive ? "메세지를 입력해주세요." : "비활성화된 모임입니다.", text: $messageText)
                        .onSubmit {
                            let messageModel: MessageModel = .init(user: "일이삼", isYou: true, message: messageText, dateString: "더미시간")
                            messageViewModel.messages.append(messageModel)
                            
                            messageText = ""
                        }
                        .textFieldStyle(.roundedBorder)
                        .tint(Color.pointColor)
                }
                .disabled(!isActive)
                .padding(.top, 5)
            }
        }
        .padding(.horizontal, 20)
        .onTapGesture {
            self.endTextEditing()
        }
        // FIXME: 모델 연동시 채팅방 제목으로
        .navigationTitle("수요일에 맥주 한잔 찌그려요~")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
    }
}

#Preview {
    NavigationStack {
        ChatView(isActive: true)
    }
}
