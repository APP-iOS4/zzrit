//
//  LoginInputView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/10/24.
//

import SwiftUI

struct LoginInputView: View {
    @Binding var text: String
    @FocusState private var focused: Bool
    
    var title: String
    var symbol: String
    var isPassword: Bool = false
    
    var inputBackground: Color {
        return focused ? .white : Color.staticGray6
    }
    
    var symbolColor: Color {
        return focused ? Color.staticGray3 : Color.staticGray4
    }
    
    var titleOffset: CGFloat {
        return focused ? -12 : 0
    }
    
    var titleFont: Font {
        return focused ? .subheadline : .title3
    }
    
    var titleOpacity: Double {
        if focused || text.count == 0 {
            return 1.0
        } else {
            return 0.0
        }
    }
    
    var textFieldOffset: CGFloat {
        if focused {
            return 10
        } else {
            return 0
        }
    }
    
    var textFieldForegroundColor: Color {
        return focused ? Color.pointColor : Color.staticGray4
    }
    
    var backgroundShadowOpacity: Double {
        return focused ? 0.1 : 0
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: 20) {
                Image(systemName: "\(symbol)")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(symbolColor)
                
                ZStack {
                    Text(title)
                        .font(titleFont)
                        .fontWeight(.bold)
                        .foregroundStyle(symbolColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .allowsHitTesting(false)
                        .offset(y: titleOffset)
                        .opacity(titleOpacity)
                    VStack {
                        if isPassword {
                            SecureField("", text: $text)
                                .fontWeight(.semibold)
                                .foregroundStyle(textFieldForegroundColor)
                                .focused($focused)
                                .offset(y: textFieldOffset)
                                .autocorrectionDisabled()
                        } else {
                            TextField("", text: $text)
                                .textInputAutocapitalization(.never)
                                .fontWeight(.semibold)
                                .foregroundStyle(textFieldForegroundColor)
                                .focused($focused)
                                .offset(y: textFieldOffset)
                                .keyboardType(.emailAddress)
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
                    .foregroundStyle(inputBackground)
                    .shadow(color: .black.opacity(backgroundShadowOpacity), radius: 8)
            }
            .animation(.easeIn, value: focused)
        }
    }
}

#Preview {
    LoginInputView(text: .constant(""), title: "아이디", symbol: "gearshape")
}
