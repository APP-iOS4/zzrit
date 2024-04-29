//
//  ContactDetailView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ContactDetailView: View {
    @EnvironmentObject private var contactService: ContactService
    @EnvironmentObject private var userService: UserService
    
    let contact: ContactModel
    
    @State private var replies: [ContactReplyModel] = []
    // 신고 대상 모임 이름
    @State private var targetRoomName: String = ""
    // 신고 대상 회원 닉네임
    @State private var targetUserName: [String] = []
    
    var body: some View {
        ScrollView {
            LazyVStack {
                // 문의내역 질문 뷰
                // FIXME: 모델 연동 시 isAnswered가 아닌 모델 받는 것으로 수정해야 함
                ContactContentView(contact: contact, targetRoomName: $targetRoomName, targetUserName: $targetUserName)
                    .padding(.bottom, 40)
                
                Divider()
                
                // 문의내역 답변 뷰
                replyView()
            }
            .padding(.horizontal, Configs.paddingValue)
        }
        .padding(.vertical, 1)
        .onAppear {
            fetchReplies()
            fetchTargetRoom()
        }
    }
    
    @ViewBuilder
    private func replyView() -> some View {
        if replies.isEmpty {
            Text("문의사항을 확인중에 있습니다.\n빠른 시일내에 답변 드리겠습니다.")
                .multilineTextAlignment(.center)
                .padding(.vertical, 100)
                .foregroundStyle(.secondary)
        } else {
            // 문의내역 답변 뷰
            ForEach(replies) { reply in
                ContactReplyView(reply: reply)
                    .padding(.top, Configs.paddingValue)
            }
        }
    }
    
    private func fetchReplies() {
        Task {
            do {
                replies = try await contactService.fetchReplies(contact.id!)
            } catch {
                Configs.printDebugMessage("에러: \(error)")
            }
        }
    }
    
    private func fetchTargetRoom() {
        if let targetRoom = contact.targetRoom, targetRoom != "" {
            Task {
                do {
                    targetRoomName = try await RoomService.shared.roomInfo(targetRoom)?.title ?? "(unknown)"
                } catch {
                    Configs.printDebugMessage("에러: \(error)")
                }
            }
        }
        
        if let targetUser = contact.targetUser, targetUser != [] {
            Task {
                targetUserName = []
                do {
                    for user in targetUser {
                        if user != "" {
                            let userModel = try await userService.findUserInfo(uid: user)
                            if let userName = userModel?.userName {
                                targetUserName.append(userName)
                            }
                        }
                    }
                } catch {
                    Configs.printDebugMessage("에러: \(error)")
                }
            }
        }
    }

}

//#Preview {
//    QuestionDetailView()
//}
