//
//  QuestionDetailView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

struct QuestionDetailView: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                // 문의내역 질문 뷰
                // FIXME: 모델 연동 시 isAnswered가 아닌 모델 받는 것으로 수정해야 함
                ContactQuestionDetailView(isAnswered: true)
                    .padding(.bottom, 40)
                
                Divider()
                
                // 문의내역 답변 뷰
                ContactReplyDetailView()
                    .padding(.top, Configs.paddingValue)
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 1)
    }
}

#Preview {
    QuestionDetailView()
}
