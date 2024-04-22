//
//  ContactReplyView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ContactReplyView: View {
    let reply: ContactReplyModel
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            // ContactReply모델에서 답변 작성 시간 주입
            Text("답변 완료일: \(DateService.shared.formattedString(date: reply.date))")
                .font(.callout)
                .foregroundStyle(Color.staticGray2)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // 답변 세부 내용
            Text(reply.content)
            .foregroundStyle(Color.staticGray2)
            .multilineTextAlignment(.leading)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.staticGray5)
                .padding(.top, Configs.paddingValue)
        }
    }
}

//#Preview {
//    ContactReplyView()
//}
