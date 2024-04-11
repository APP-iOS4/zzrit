//
//  ContactManagerAnswerView.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/9/24.
//

import SwiftUI

struct ContactManagerAnswerView: View {
    @Binding var contactAnswerText: String
    var body: some View {
        VStack() {
            HStack {
                Text("문의 답변")
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top)
            TextField("문의에 대한 답변을 입력해 주세요.", text: $contactAnswerText)
                .padding(20)
                .frame(height: 150, alignment: .topLeading)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.staticGray3, lineWidth: 1.0)
                }
        }
    }
}
