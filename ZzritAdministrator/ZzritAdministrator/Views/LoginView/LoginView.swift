//
//  LoginView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/10/24.
//

import SwiftUI
import ZzritKit

struct LoginView: View {
    private let authService = AuthenticationService.shared
    private let userService = UserService()
    
    @State var id: String = ""
    @State var pw: String = ""
    @State var isLoginButtonActive: Bool = false
    @State var isCanLogin: Bool = false
    
    @Binding var isLogin: Bool
    @State private var showError = false
    
    @Binding var adminName: String
    @Binding var adminID: String
    
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
                            
                            if showError {
                                Text("이메일이나 비밀번호를 다시 확인해 주세요.")
                                    .font(.subheadline.bold())
                                    .foregroundStyle(.red)
                            }
                        }
                        VStack(alignment: .trailing) {
                            Text("비밀번호 분실시 관리자에게 문의하세요")
                                .foregroundStyle(Color.staticGray2)
                                .padding(10.0)
                            
                            // TODO: Login 로직 추가(필요)
                            Button {
                                login()
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
    
    private func login() {
        Task {
            do {
                try await authService.loginAdmin(email: id, password: pw)
                if let admin = try await userService.loginedAdminInfo() {
                    adminName = admin.name
                    adminID = admin.email
                    
                    isLogin = true
                    showError = false
                }
            } catch {
                showError = true
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    LoginView(isLogin: .constant(false), adminName: .constant(""), adminID: .constant(""))
}
