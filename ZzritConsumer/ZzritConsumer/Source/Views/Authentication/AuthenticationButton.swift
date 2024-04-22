//
//  AuthenticationButton.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/15/24.
//

import SwiftUI

struct AuthenticationButton: View {
    
    let type: AuthenticationType
    
    let tapAction: () -> ()
    
    private var description: String {
        switch type {
        case .login:
            return "이미 계정이 있으신가요?"
        case .register:
            return "아직 계정이 없으신가요?"
        }
    }
    
    var body: some View {
        HStack {
            Text(description)
            Button(type.rawValue) {
                tapAction()
            }
            .foregroundStyle(Color.pointColor)
            .fontWeight(.bold)
        }
        .font(.subheadline)
    }
}

#Preview {
    AuthenticationButton(type: .login) {
        
    }
}
