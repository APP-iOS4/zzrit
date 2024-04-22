//
//  SignUpAgreeButton.swift
//  ZzritConsumer
//
//  Created by Irene on 4/8/24.
//

import SwiftUI

struct SignUpAgreeButton: View {
    @Binding var selectAgree: Bool
    var body: some View {
        HStack {
            if selectAgree{
                Image(systemName: "checkmark.circle")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.pointColor)
            } else{
                Image(systemName: "circle")
            }
            Text("서비스 이용약관 동의")
            Spacer()
            Text("보기")
                .underline()
        }
        .foregroundStyle(Color.staticGray2)
    }
}

#Preview {
    SignUpAgreeButton(selectAgree: .constant(true))
}
