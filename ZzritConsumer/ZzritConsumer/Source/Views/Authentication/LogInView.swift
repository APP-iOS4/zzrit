//
//  LogInView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/8/24.
//

import SwiftUI

import ZzritKit

struct LogInView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var userService: UserService
    private let authService = AuthenticationService.shared
    
    @State private var id: String = ""
    @State private var pw: String = ""
    
    @State private var pressSignUpButton: Bool = false
    @State private var isLoginButtonActive: Bool = false
    @State private var isShowingRegisterView: Bool = false
    @State private var failLogIn = false
    @State private var errorMessage: String = ""
    @State private var showProfile = false
    @State private var googleEmailID = ""
    @State private var registerdID = ""
    
    var body: some View {
        NavigationStack {
            HStack {
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .padding()
                        .font(.title3)
                }
                .tint(.primary)
            }
            
            VStack {
//                Image("ZziritLogoImage")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(height: 180)
                AppSlogan()
                
                Spacer(minLength: 50)
                
                // MARK: 로그인 입력란
                if #available(iOS 17.0, *) {
                    UserInputCellView(text: $id, title: "이메일", symbol: "envelope")
                        .onChange(of: id, {
                            activeLoginButton()
                        })
                    UserInputCellView(text: $pw, title: "비밀번호", symbol: "lock", isPassword: true)
                        .onChange(of: pw, {
                            activeLoginButton()
                        })
                } else {
                    UserInputCellView(text: $id, title: "이메일", symbol: "envelope")
                        .onChange(of: id, perform: { value in
                            activeLoginButton()
                        })
                    UserInputCellView(text: $pw, title: "비밀번호", symbol: "lock", isPassword: true)
                        .onChange(of: id, perform: { value in
                            activeLoginButton()
                        })
                }
                
                
                HStack {
                    Spacer()
                    Button(action: {
                        resetPassword()
                    }, label: {
                        Text("비밀번호를 잊으셨나요?")
                    })
                }
                .font(.subheadline)
                .foregroundColor(Color.pointColor)
                .padding(.top, 10)
                
                GeneralButton("로그인", isDisabled: !isLoginButtonActive) {
                    login()
                }
                
                SocialLoginButton(type: .google) {
                    Task {
                        googleSignIn()
                    }
                }
                .navigationDestination(isPresented: $showProfile) {
                    SetProfileView(emailField: googleEmailID, registeredUID: $registerdID)
                }
                
                Spacer(minLength: 50)
                
                VStack(spacing: 20) {
                    if errorMessage != "" {
                        AuthenticationErrorView(title: $errorMessage)
                    }
                    
                    AuthenticationButton(type: .register) {
                        isShowingRegisterView.toggle()
                    }
                    .fullScreenCover(isPresented: $isShowingRegisterView) {
                        SignUpView()
                    }
                }
            }
            .padding(20)
            .onAppear {
                id = ""
                pw = ""
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
    
    /// 아이디, 이메일 로그인
    private func login() {
        Task {
            do {
                try await authService.loginUser(email: id, password: pw)
                dismiss()
            } catch {
                errorMessage = "로그인 정보를 확인해주세요."
            }
        }
    }
    
    /// 구글 로그인
    private func googleSignIn() {
        Task {
            do {
                try await authService.loginWithGoogle()
                
                if let userId = try await userService.loginedUserInfo()?.id {
                    _ = try await userService.getUserInfo(uid: userId)
                }
                dismiss()
            } catch AuthError.noUserInfo {
                registerdID = authService.currentUID!
                Configs.printDebugMessage("id는 이거 : \(registerdID)")
                showProfile.toggle()
            } catch {
                errorMessage = "오류가 발생했습니다.\n잠시 후 다시 시도해주시기 바랍니다."
            }
        }
    }
    
    /// 비밀번호 재설정 링크 발송
    private func resetPassword() {
        Task {
            do {
                try await authService.resetPassword(email: id)
            } catch {
                Configs.printDebugMessage("에러: \(error)")
                errorMessage = "오류가 발생했습니다.\n잠시 후 다시 시도해주시기 바랍니다."
            }
        }
    }
}

#Preview {
    LogInView()
        .environmentObject(UserService())
}
