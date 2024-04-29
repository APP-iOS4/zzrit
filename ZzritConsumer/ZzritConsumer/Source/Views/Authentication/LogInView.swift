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
    @EnvironmentObject private var restrictionViewModel: RestrictionViewModel
    
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
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
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
                    AppSlogan()
                    
                    Spacer(minLength: 50)
                    
                    // MARK: 로그인 입력란
                    UserInputCellView(text: $id, title: "이메일", symbol: "envelope")
                        .customOnChange(of: id) { _ in
                            activeLoginButton()
                        }
                    UserInputCellView(text: $pw, title: "비밀번호", symbol: "lock", isPassword: true)
                        .customOnChange(of: pw) { _ in
                            activeLoginButton()
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
                        SetProfileView(isTopDismiss: $isShowingRegisterView, emailField: googleEmailID, registeredUID: $registerdID)
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
                            SignUpView(isTopDismiss: $isShowingRegisterView)
                        }
                    }
                }
                .padding(20)
                .onAppear {
                    id = ""
                    pw = ""
                }
            }
            .loading(isLoading)
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
                isLoading.toggle()
                try await authService.loginUser(email: id, password: pw)
                if let id = try await userService.loggedInUserInfo()?.id {
                    restrictionViewModel.loadRestriction(userID: id)
                }
                isLoading.toggle()
                
                dismiss()
            } catch {
                isLoading = false
                errorMessage = "로그인 정보를 확인해주세요."
            }
        }
    }
    
    /// 구글 로그인
    private func googleSignIn() {
        Task {
            do {
                try await authService.loginWithGoogle()
                
                if let userId = try await userService.loggedInUserInfo()?.id {
                    _ = try await userService.findUserInfo(uid: userId)
                }
                dismiss()
            } catch AuthError.noUserInfo {
                registerdID = authService.currentUID!
                Configs.printDebugMessage("id는 이거 : \(registerdID)")
                print("id는 이거 : \(registerdID)")
                googleEmailID = authService.currentUserEmail!
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
