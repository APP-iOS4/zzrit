//
//  QuestionListView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct QuestionListView: View {
    
    let contacts: [ContactModel]
    
    //MARK: - body
    
    var body: some View {
        List (contacts) { contact in
            NavigationLink {
                // 상세 페이지
                // FIXME: 모델 받는 것으로 수정해야 함
                QuestionDetailView(contact: contact)
            } label: {
                // 리스트에 보여줄 셀들
                // FIXME: 모델 연동 시 isAnswered가 아닌 모델 받는 것으로 수정해야 함
                QuestionListCellView(contact: contact)
            }
        }
        .listStyle(.plain)
        .padding(.vertical, 1)
    }
}

#Preview {
    QuestionListView(contacts: [])
}
