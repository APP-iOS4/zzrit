//
//  QuestionDetailView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ContactQuestionDetailView: View {
    // 임시 문의 답변 상황
    var isAnswered: Bool
    // 임시 문의 종류 변수
    let contactCategory: ContactCategory = .room
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            // 문의 종류 카테고리 주입
            Text(contactCategory.rawValue)
                .font(.footnote)
                .foregroundStyle(Color.pointColor)
            
            // 문의내역 타이틀 주입
            Text("스태틱 문의제목입니다.")
                .font(.title3)
            
            // 문의내역 답변상황 및 문의 등록 날짜
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
            .padding(.bottom, 30)
            
            //모임 제목을 주입
            Text("모임 : 수요일에 맥주 한잔 찌끄려요~")
                .padding(.bottom, 5)
            
            // 문의 세부 내용을 주입
            Text("스태틱 문의 내용입니다. 누가 자꾸 분탕질을 해요. 화가 많이 납니다.")
                .foregroundStyle(Color.staticGray2)
        }
        .toolbarRole(.editor)
    }
}

#Preview {
    ContactQuestionDetailView(isAnswered: true)
}
