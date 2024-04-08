//
//  LoginInputView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/8/24.
//

import SwiftUI

struct LoginInputView: View {
    @Binding var text: String
    @FocusState private var focused: Bool
    
    var title: String
    var symbol: String
    var isPassword: Bool = false

    var titleOpacity: Double {
        if text.count != 0 {
            return 0.0
        } else {
            return 1.0
        }
    }
    
    var backgroundShadowOpacity: Double {
        return focused ? 0.1 : 0
    }
    
    var textFieldForegroundColor: Color {
        return focused ? Color.pointColor : Color.staticGray4
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: 20) {
                Image(systemName: "\(symbol)")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.staticGray3)
                
                ZStack {
                    Text("\(title)")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.staticGray3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .allowsHitTesting(false)
                        .offset(y: 0)
                        .opacity(titleOpacity)
                    VStack {
                        // TODO: focus id -> pw 바뀌는거 
                        if isPassword {
                            SecureField("", text: $text)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.pointColor)
                                .focused($focused)
                                .submitLabel(.go)
                                .autocorrectionDisabled()
                        } else {
                            TextField("", text: $text)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.pointColor)
                                .focused($focused)
                                .keyboardType(.emailAddress)
                                .submitLabel(.next)
                                .autocorrectionDisabled()
                        }
                    }
                    .padding(.vertical, 15)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(backgroundShadowOpacity), radius: 8)
            }
            .animation(.easeIn, value: focused)
        }
    }
}

#Preview {
    LoginInputView(text: .constant(""), title: "아이디", symbol: "gearshape")
}
