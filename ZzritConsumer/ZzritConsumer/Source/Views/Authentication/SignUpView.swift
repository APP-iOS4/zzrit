//
//  SignUpView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/8/24.
//

import SwiftUI

import ZzritKit

struct SignUpView: View {
    private let authService = AuthenticationService.shared
    
    @State private var signUpId: String = ""
    @State private var signUpPw1: String = ""
    @State private var signUpPw2: String = ""
    @State private var agreeSheet = false
    @State private var showProfile = false
    @State private var selectAgree = false
    @State private var equlText = false
    @State private var isSignUpButtonActive: Bool = false
    @State private var registeredUID: String = ""
    @State private var isLoading: Bool = false
    
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                AppSlogan()
                
                Spacer(minLength: 50)
                
                UserInputCellView(text: $signUpId, title: "이메일", symbol: "envelope")
                    .customOnChange(of: signUpId) { _ in
                        activeSignUpButton()
                    }
                
                // MARK: 이메일 형식 체크 오류 메시지
                if !signUpId.isEmpty {
                    if checkEmail(signUpId){
                        SpaceErrorTextView()
                    } else {
                        ErrorTextView(title: "이메일 형식이 올바르지 않습니다.")
                    }
                } else {
                    ErrorTextView(title: "이메일 형식에 맞게 입력해주세요.")
                }
                UserInputCellView(text: $signUpPw1, title: "비밀번호", symbol: "lock", isPassword: true)
                    .customOnChange(of: signUpPw1) { _ in
                        activeSignUpButton()
                    }
                UserInputCellView(text: $signUpPw2, title: "비밀번호 확인", symbol: "lock", isPassword: true)
                    .customOnChange(of: signUpPw2) { _ in
                        activeSignUpButton()
                    }
                
                // MARK: 비밀번호 일치 여부 확인 메시지
                if !equlText {
                    if signUpPw1.isEmpty || signUpPw2.isEmpty {
                        ErrorTextView(title: "비밀번호 입력란은 모두 채워주세요.")
                    } else {
                        ErrorTextView(title: "비밀번호가 일치하지 않습니다.")
                    }
                } else {
                    if signUpPw1.count < 8 || signUpPw2.count < 8 {
                        ErrorTextView(title: "8글자 이상의 영어, 숫자, 문자로 입력해주세요.")
                    }else {
                        ErrorTextView(title: " ")
                    }
                }
                
                // MARK: 이용약관 동의 버튼
                SignUpAgreeButton(selectAgree: $selectAgree)
                    .onTapGesture {
                        if selectAgree {
                            selectAgree = false
                        } else {
                            agreeSheet.toggle()
                        }
                    }
                    .sheet(isPresented: $agreeSheet, content: {
                        ServiceAgreeSheet(selectAgree: $selectAgree, agreeSheet: $agreeSheet)
                    })
                    .padding(.top, Configs.paddingValue)
                
                // MARK: 회원가입 버튼
                GeneralButton("회원가입", isDisabled: !isSignUpButtonActive) {
                    register()
                }
                .customOnChange(of: selectAgree) { _ in
                    activeSignUpButton()
                }
                .navigationDestination(isPresented: $showProfile) {
                    SetProfileView(emailField: signUpId, registeredUID: $registeredUID)
                }
                
                Spacer(minLength: 50)
                
                AuthenticationButton(type: .login) {
                    dismiss()
                }
            }
            .padding(Configs.paddingValue)
            .toolbarRole(.editor)
        }
        .loading(isLoading, message: "계정을 생성하고 있습니다.")
    }
    
    func activeSignUpButton() {
        if !signUpId.isEmpty && !signUpPw1.isEmpty && !signUpPw2.isEmpty {
            if signUpPw1 == signUpPw2 {
                equlText = true
                if selectAgree {
                    if checkEmail(signUpId) {
                        if checkPassword(signUpPw1) {
                            isSignUpButtonActive = true
                        } else {
                            isSignUpButtonActive = false
                        }
                    } else {
                        isSignUpButtonActive = false
                    }
                } else {
                    isSignUpButtonActive = false
                }
            } else {
                isSignUpButtonActive = false
            }
        } else {
            isSignUpButtonActive = false
        }
    }
    
    private func checkEmail( _ str: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: str)
    }
    
    private func checkPassword( _ str: String) -> Bool {
        let pwRegex = "[A-Za-z0-9!_@$%^&+=]{8,20}"
        return NSPredicate(format: "SELF MATCHES %@", pwRegex).evaluate(with: str)
    }
    
    private func register() {
        isLoading.toggle()
        Task {
            do {
                let register = try await authService.register(email: signUpId, password: signUpPw1)
                Configs.printDebugMessage("회원가입 성공, 생성된 계정 uid: \(register.user.uid)")
                registeredUID = register.user.uid
                isLoading.toggle()
                showProfile.toggle()
            } catch {
                isLoading = false
                Configs.printDebugMessage("에러: \(error)")
            }
        }
    }
}

#Preview {
    SignUpView()
}
