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
    @State private var registeredUID: String = ""
    
    var body: some View {
        TextField("이메일", text: $emailField)
        TextField("비밀번호", text: $passwordField)
        
        HStack {
            Button("로그인") {
                login()
            }
            
            Button("회원가입") {
                register()
            }

            Spacer()
            
            Button("로그아웃") {
                logout()
            }
        }
        
        Button("현재 로그인 정보") {
            currentLoginedUser()
        }
        
        HStack {
            Button("현재 로그인 계정 탈퇴") {
                secession()
            }
            
            Spacer()
            
            Button("현재 로그인 계정 탈퇴 철회") {
                secessionCancel()
            }
        }
    }
    
    // MARK: Authentication Service Method
    
    private func login() {
        Task {
            do {
                try await authService.loginUser(email: emailField, password: passwordField)
                print("로그인 성공")
                
                if let userInfo = try await userService.loginedUserInfo() {
                    if await userInfo.isSecession() {
                        print("회원탈퇴 처리중")
                    } else {
                        print("회원탈퇴 이력 없음")
                    }
                }
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
                registeredUID = register.user.uid
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    private func setUserInfo() {
        do {
            let userInfo: UserModel = .init(userID: emailField, userName: "닉네임", userImage: "", gender: .male, birthYear: 1994, staticGuage: 20.0)
            try userService.setUserInfo(uid: registeredUID, info: userInfo)
        } catch {
            print("에러: \(error)")
        }
    }
    
    private func logout() {
        do {
            try authService.logout()
            print("로그아웃 성공")
        } catch {
            print("에러: \(error)")
        }
    }
    
    private func currentLoginedUser() {
        Task {
            do {
                if let loginedUserInfo = try await userService.loginedUserInfo() {
                    print("loginedUserInfo: \(loginedUserInfo)")
                } else {
                    print("유저 정보가 DB에 없음")
                }
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    private func secession() {
        Task {
            do {
                try await userService.secession()
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    private func secessionCancel() {
        Task {
            do {
                try await userService.secessionCancel()
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    LoginView()
}
