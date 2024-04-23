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
    
    let contact: ContactModel
    
    @State private var replies: [ContactReplyModel] = []
    
    var body: some View {
        ScrollView {
            LazyVStack {
                // 문의내역 질문 뷰
                // FIXME: 모델 연동 시 isAnswered가 아닌 모델 받는 것으로 수정해야 함
                ContactContentView(contact: contact)
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
}

//#Preview {
//    QuestionDetailView()
//}
