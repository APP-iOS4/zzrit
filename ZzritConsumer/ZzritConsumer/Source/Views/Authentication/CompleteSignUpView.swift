//
//  CompleteSignUpView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

struct CompleteSignUpView: View {
    @Environment (\.dismiss) private var dismiss
    
    @Binding var isTopDismiss: Bool
    
    var body: some View {
        VStack {
            Spacer()
            Image("ZziritLogoImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
            VStack {
                Text("회원가입이 완료되었습니다.")
                Text("지금 바로 모임을 찾아보세요!")
            }
            .font(.title3)
            .foregroundStyle(Color.staticGray2)
            Spacer()
            GeneralButton("로그인하러가기") {
                isTopDismiss.toggle()
            }
        }
        .padding(20)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    CompleteSignUpView(isTopDismiss: .constant(false))
}
