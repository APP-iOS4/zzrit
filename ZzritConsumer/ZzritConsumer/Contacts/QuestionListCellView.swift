//
//  QuestionListCellView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

struct QuestionListCellView: View {
    var isAnswered: Bool
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            // 받은 문의내역의 제목
            Text("스태틱 문의제목 입니다.")
                .foregroundStyle(Color.staticGray1)
            
            HStack {
                // 문의 내역의 현재 상태
                Text(isAnswered ? "답변완료" : "접수완료")
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .font(.footnote)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2.0)
                    }
                    .foregroundStyle(isAnswered ? Color.pointColor : Color.staticGray3)
                    .background(isAnswered ? Color.lightPointColor : .white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                // 문의 내역의 등록 날짜
                Text("2024.00.00")
                    .font(.footnote)
                    .foregroundStyle(Color.staticGray3)
            }
        }
    }
}

#Preview {
    QuestionListCellView(isAnswered: true)
}
