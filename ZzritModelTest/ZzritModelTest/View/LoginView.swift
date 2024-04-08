//
//  LoginView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/8/24.
//

import SwiftUI

import ZzritKit

struct LoginView: View {
    private let authService = AuthenticationService.shared
    private let userService = UserService()
    @State private var emailField: String = "test@test.com"
    @State private var passwordField: String = "testpassword"
    
    var body: some View {
        TextField("이메일", text: $emailField)
        TextField("비밀번호", text: $passwordField)
        Button("로그인") {
            login()
        }
        
        Button("회원가입") {
            register()
        }
    }
    
    private func login() {
        Task {
            do {
                try await authService.loginUser(email: emailField, password: passwordField)
                print("로그인 성공")
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    private func register() {
        Task {
            do {
                let register = try await authService.register(email: emailField, password: passwordField)
                print("회원가입 성공, 생성된 계정 uid: \(register.user.uid)")
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    LoginView()
}
