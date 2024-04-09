//
//  QuestionListView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

struct QuestionListView: View {
    
    //MARK: - body
    
    var body: some View {
        List (0...3, id: \.self) { _ in
            NavigationLink {
                // 상세 페이지
                // FIXME: 모델 받는 것으로 수정해야 함
                QuestionDetailView()
            } label: {
                // 리스트에 보여줄 셀들
                // FIXME: 모델 연동 시 isAnswered가 아닌 모델 받는 것으로 수정해야 함
                QuestionListCellView(isAnswered: true)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    QuestionListView()
}
