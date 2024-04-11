//
//  CreateAdminAccountView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/11/24.
//

import SwiftUI

import ZzritKit

struct CreateAdminAccountView: View {
    private let authService = AuthenticationService.shared
    private let userService = UserService()
    
    @State private var accountEmail: String = ""
    @State private var accountPassword: String = ""
    @State private var adminName: String = ""
    @State private var adminEmail: String = ""
    @State private var adminLevel: Bool = false
    
    @State private var isShowingAlert: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var buttonDisabled: Bool = false
    
    var body: some View {
        Form {
            Section("Firebase 계정") {
                TextField("이메일을 입력하세요.", text: $accountEmail)
                SecureField("비밀번호를 입력하세요.", text: $accountPassword)
            }
            
            Section("관리자 정보") {
                TextField("관리자 이름을 입력하세요.", text: $adminName)
                TextField("관리자 이메일을 입력하세요.", text: $adminEmail)
                Toggle(isOn: $adminLevel) {
                    Text("관리자 레벨(true = 최고권한)")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("생성") {
                    buttonDisabled = true
                    createAdminAccount()
                }
                .disabled(buttonDisabled)
            }
        }
        .alert("완료", isPresented: $isShowingAlert) {
            Button("확인", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("관리자 계정 생성이 완료되었습니다.")
        }

    }
    
    private func createAdminAccount() {
        Task {
            do {
                let adminType: AdminType = adminLevel ? .master : .normal
                
                let tempModel: AdminModel = .init(name: adminName, email: adminEmail, level: adminType)
                
                let register = try await authService.register(email: accountEmail, password: accountPassword)
                
                try userService.setUserInfo(admin: register.user.uid, info: tempModel)
                
                isShowingAlert.toggle()
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    CreateAdminAccountView()
}
