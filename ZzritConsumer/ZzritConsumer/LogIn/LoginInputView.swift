//
//  LoginInputView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/8/24.
//

import SwiftUI

struct LoginInputView: View {
    enum Field: Hashable {
        case username
        case password
    }
    @Binding var text: String
    @FocusState private var focusedField: Field?
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
        return 0
    }
    
    var titleFont: Font {
        return .subheadline
    }
    
    var titleOpacity: Double {
        print(text.count)
        if text.count != 0 {
            print(text.count)
            return 0.0
        } else {
            return 1.0
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
                    Text("\(title)")
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
                                .foregroundStyle(Color.pointColor)
                                .focused($focusedField, equals: .password)
                                .submitLabel(.go)
                                .autocorrectionDisabled()
                                .onSubmit {
                                    self.focusedField = nil
                                }
                        } else {
                            TextField("", text: $text)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.pointColor)
                                .focused($focusedField, equals: .username)
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
