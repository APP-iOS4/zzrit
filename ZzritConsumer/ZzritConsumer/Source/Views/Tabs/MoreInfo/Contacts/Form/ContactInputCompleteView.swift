//
//  ContactInputCompleteView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ContactInputCompleteView: View {
    @State private var isPressConfirmButton: Bool = false
    
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(.zziritLogo)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 250, height: 250)
            
            Text("문의가 등록 되었어요.\n확인 후 빠르게 답변해드릴게요!")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Color.staticGray1)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            GeneralButton("확인") {
                isPresented = false
            }
            .padding(Configs.paddingValue)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    ContactInputCompleteView(isPresented: .constant(true))
}
