//
//  AuthenticationErrorView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/15/24.
//

import SwiftUI

struct AuthenticationErrorView: View {
    @Binding var title: String
    
    var body: some View {
        Text(title)
            .font(.subheadline)
            .foregroundStyle(Color.red)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(Color.lightPointColor)
            .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    AuthenticationErrorView(title: .constant("오류메세지 입력"))
}
