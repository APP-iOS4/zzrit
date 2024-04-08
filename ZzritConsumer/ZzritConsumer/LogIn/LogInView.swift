//
//  LogInView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/8/24.
//

import SwiftUI
import ZzritKit

struct LogInView: View {
    
    @State var id: String = ""
    @State var pw: String = ""
    @State var isLoginButtonActive: Bool = false
    @State var failLogin = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image("StaticLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text("만나는 순간의 짜릿함")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color.staticGray1)
            Text("ZZ!LIT")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundStyle(Color.pointColor)
            if failLogin {
                Text("로그인 정보를 다시 확인해 주세요.")
            } else {
                Text("")
            }
            if #available(iOS 17.0, *) {
                LoginInputView(text: $id, title: "이메일", symbol: "envelope")
                    .onChange(of: id, {
                        activeLoginButton()
                    })
                LoginInputView(text: $pw, title: "비밀번호", symbol: "lock", isPassword: true)
                    .onChange(of: pw, {
                        activeLoginButton()
                    })
            } else {
                // Fallback on earlier versions
                LoginInputView(text: $id, title: "이메일", symbol: "envelope")
                    .onChange(of: id, perform: { value in
                        activeLoginButton()
                    })
                LoginInputView(text: $pw, title: "비밀번호", symbol: "lock", isPassword: true)
                    .onChange(of: id, perform: { value in
                        activeLoginButton()
                    })
            }
            HStack {
                Button(action: {
                    
                }, label: {
                    Text("회원가입")
                })
                .foregroundColor(Color.pointColor)
                Spacer()
                Button(action: {
                    
                }, label: {
                    Text("비밀번호를 잊으셨나요?")
                })
                .foregroundColor(Color.pointColor)
            }
            GeneralButton(isDisabled: !isLoginButtonActive, "로그인") {
                print("asdfasdfasdfasdfasdf")
            }
        }
    }
    func activeLoginButton() {
        if !id.isEmpty && !pw.isEmpty {
            isLoginButtonActive.toggle()
        } else {
            isLoginButtonActive = false
        }
    }
}

#Preview {
    LogInView()
}
