//
//  LoginView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/10/24.
//

import SwiftUI
import ZzritKit

struct LoginView: View {
    @State var id: String = ""
    @State var pw: String = ""
    @State var isLoginButtonActive: Bool = false
    @State var isCanLogin: Bool = false
    
    @Binding var isLogin: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                HStack() {
                    VStack(spacing: 10.0) {
                        Image(.staticLogo)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 330.0, height: 200)
                            .padding(.bottom, 30)
                        
                        Text("만나는 순간의 짜릿함")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.staticGray1)
                        
                        Text("ZZ!RIT")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .kerning(2.2)
                            .foregroundStyle(Color.pointColor)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(spacing: 50.0) {
                        VStack {
                            LoginInputView(text: $id, title: "이메일", symbol: "envelope")
                                .padding(10.0)
                                .onChange(of: id) { newValue in
                                    activeLoginButton()
                                }
                            LoginInputView(text: $pw, title: "비밀번호", symbol: "lock", isPassword: true)
                                .padding(10.0)
                                .onChange(of: pw) { newValue in
                                    activeLoginButton()
                                }
                        }
                        VStack(alignment: .trailing) {
                            Text("비밀번호 분실시 관리자에게 문의하세요")
                                .foregroundStyle(Color.staticGray2)
                                .padding(10.0)
                            
                            // TODO: Login 로직 추가(필요)
                            Button {
                                isLogin = true
                                
                                // 레거시 코드(로구인에 필요할 듯)
//                                isCanLogin = true
//                                checkSignInUser()
//                                if !isCanLogin {
//                                    
//                                }
                            } label: {
                                StaticTextView(title: "로그인", selectType: .login, isActive: $isLoginButtonActive)
                            }
                            .disabled(!isLoginButtonActive)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.trailing, 60)
                
                Spacer()
            }
            .background(Color.staticGray6.ignoresSafeArea(.all))
            .onTapGesture {
                // hideKeyboard()
            }
        }
    }
    
    func activeLoginButton() {
        if !id.isEmpty && !pw.isEmpty {
            isLoginButtonActive = true
        } else {
            isLoginButtonActive = false
        }
    }
    
    // 레거시 코드 추후 활용 예정
//    func checkSignInUser() {
//        Task {
//            isCanLogin = await AuthorizationService.shared.signInUser(withAdmin:
//                    UserSignInModel(userID: id, userPW: pw)
//                )
//        }
//        
//        print("isCanLogin = \(isCanLogin)")
//    }
}

#Preview {
    LoginView(isLogin: .constant(false))
}
