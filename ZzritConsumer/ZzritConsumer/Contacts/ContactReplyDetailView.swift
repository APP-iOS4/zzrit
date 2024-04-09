//
//  ContactReplyDetailView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

struct ContactReplyDetailView: View {
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            // ContactReply모델에서 답변 작성 시간 주입
            Text("답변 완료일: 2024.00.00")
                .font(.callout)
                .foregroundStyle(Color.staticGray2)
                .padding(.bottom, 10)
            
            // 답변 세부 내용
            Text("""
                OO님, 안녕하세요. 문의하신 OOO에 대해 답변 드립니다.
                
                문의내역 답변란입니다. 자리를 채워보고 싶어서 아무말이나 길게 써보겠습니다. ㅎㅎ 보시고 수정사항 있으시면 말씀 부탁드립니다.
                
                좋은하루 보내세요. ^.^ 스태틱 고객센터 담당자 김예지였습니다.
                
                ※ 추가로 궁금하신 내용이 있으시면 스태틱 고객센터로 연락부탁드립니다.
                """)
            .foregroundStyle(Color.staticGray2)
            .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    ContactReplyDetailView()
}
