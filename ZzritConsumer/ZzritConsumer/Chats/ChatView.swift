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
        // 공지사항: 방의 세부 정보
        ChatRoomNoticeView()
        Divider()
        
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(messageViewModel.messages) { message in
                        // 메세지가 상대방일 경우
                        if !message.isYou {
                            LazyVStack(alignment: .leading) {
                                ChatMessageCellView(message: message)
                            }
                            //  메세지가 내꺼일 경우
                        } else if message.isYou {
                            LazyVStack(alignment: .trailing) {
                                ChatMessageCellView(message: message)
                            }
                        } else {
                            // 어떻게 벌써 12시~~
                            HStack {
                                Text("2024년 4월 12일 금요일")
                                    .font(.caption)
                                    .foregroundStyle(Color.staticGray3)
                                    .frame(maxWidth: .infinity)
                            }
                            // 누군가 두둥등쟝 ✨
                            // JoinedUserModel
                            Text("\(message.user)님께서 입장하셨어요.")
                                .foregroundStyle(Color.pointColor)
                                .padding(10)
                                .frame(maxWidth: .infinity)
                                .background(Color.lightPointColor)
                                .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
                        }
                    }
                }
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
                                let messageModel: MessageModel = .init(user: "일이삼", isYou: true, message: messageText, dateString: "더미시간")
                                messageViewModel.messages.append(messageModel)
                                
                                messageText = ""
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
                    .background(RoundedRectangle(cornerRadius: Configs.cornerRadius).foregroundStyle(Color.staticGray6))
                }
                .disabled(!isActive)
                .padding(.top, 5)
            }
        }
        .padding(.horizontal, Configs.paddingValue)
        .onTapGesture {
            self.endTextEditing()
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
}

#Preview {
    NavigationStack {
        ChatView(isActive: true)
    }
}
