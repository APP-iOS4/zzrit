//
//  QuestionView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

struct QuestionView: View {
    // 문의 내용 작성 버튼을 눌렀는지
    @State private var isTopTrailingAction: Bool = false
    
    //MARK: - body
    
    var body: some View {
        VStack {
            // 문의 목록 리스트 뷰
            QuestionListView()
        }
        .toolbarRole(.editor)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        isTopTrailingAction.toggle()
                    } label: {
                        Image(systemName: "pencil.line")
                            .foregroundStyle(.black)
                    }
                    // 문의 내용 작성 뷰로 이동하는 navigationDestination
                    .navigationDestination(isPresented: $isTopTrailingAction) {
                        ContactInputView()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        QuestionView()
    }
}
