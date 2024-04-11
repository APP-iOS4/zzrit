//
//  AdminLoginView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/11/24.
//

import SwiftUI

import ZzritKit

struct AdminLoginView: View {
    private let authService = AuthenticationService.shared
    private let userService = UserService()
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var buttonDisabled: Bool = false
    @State private var isLogined: Bool = false
    
    var body: some View {
        Form {
            Section("로그인 및 관리자 검증") {
                TextField("이메일을 입력하세요.", text: $email)
                SecureField("비밀번호를 입력하세요.", text: $password)
                Button(isLogined ? "로그아웃" : "로그인") {
                    buttonDisabled.toggle()
                    if isLogined {
                        logout()
                    } else {
                        login()
                    }
                }
                .disabled(buttonDisabled)
            }
        }
    }
    
    private func login() {
        Task {
            do {
                try await authService.loginAdmin(email: email, password: password)
                if let _ = try await userService.loginedAdminInfo() {
                    isLogined = true
                }
                buttonDisabled.toggle()
            } catch {
                buttonDisabled.toggle()
                print("에러: \(error)")
            }
        }
    }
    
    private func logout() {
        do {
            try authService.logout()
            isLogined = false
            buttonDisabled.toggle()
        } catch {
            buttonDisabled.toggle()
            print("에러: \(error)")
        }
    }
}

#Preview {
    AdminLoginView()
}
