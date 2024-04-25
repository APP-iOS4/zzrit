//
//  SocialLoginButton.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/15/24.
//

import SwiftUI

struct SocialLoginButton: View {
    
    let type: SocialLoginType
    
    let tapAction: () -> ()
    
    private var backgroundColor: Color {
        switch type {
        case .google:
            return .clear
        }
    }
    
    private var textColor: Color {
        switch type {
        case .google:
            return .primary
        }
    }
    
    private var borderColor: Color {
        switch type {
        case .google:
            return Color.staticGray4
        }
    }

    var body: some View {
        Button {
            tapAction()
        } label: {
            Text(type.buttonString)
                .frame(maxWidth: .infinity)
                .foregroundStyle(textColor)
                .padding()
                .background(backgroundColor)
                .clipShape(.rect(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(borderColor, lineWidth: 1)
                    HStack {
                        Image("\(type)")
                        Spacer()
                    }
                    .padding(.leading, 10)
                }
        }
    }
}

#Preview {
    SocialLoginButton(type: .google) {

    }
}
