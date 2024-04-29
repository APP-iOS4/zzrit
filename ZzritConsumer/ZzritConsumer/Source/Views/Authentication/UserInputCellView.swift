//
//  LoginInputView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/8/24.
//

import SwiftUI

struct UserInputCellView: View {
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
    
    var symbolColor: Color {
        return focused ? Color.staticGray3 : Color.staticGray4
    }
    
    var backgroundShadowOpacity: Double {
        return focused ? 0.1 : 0
    }
    
    var textFieldForegroundColor: Color {
        return focused ? Color.pointColor : Color.staticGray4
    }
    
    var borderOpacity: Double {
        return focused ? 0 : 1
    }
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Image(systemName: "envelope")
                    .fontWeight(.medium)
                    .foregroundStyle(Color.clear)
                
                Image(systemName: "\(symbol)")
                    .fontWeight(.medium)
                    .foregroundStyle(symbolColor)
                //                .frame(width: 30.0, alignment: .center)
            }
                
            ZStack {
                Text("\(title)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(symbolColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .allowsHitTesting(false)
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
                            .padding(.vertical, 10)
                            .textInputAutocapitalization(.never)
                    } else {
                        TextField("", text: $text)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.pointColor)
                            .focused($focused)
                            .keyboardType(.emailAddress)
                            .submitLabel(.next)
                            .autocorrectionDisabled()
                            .padding(.vertical, 10)
                            .textInputAutocapitalization(.never)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(backgroundShadowOpacity), radius: 8)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.staticGray5.opacity(borderOpacity), lineWidth: 1)
        }
        .animation(.easeIn, value: focused)
    }
}

#Preview {
    UserInputCellView(text: .constant(""), title: "아이디", symbol: "gearshape")
}
