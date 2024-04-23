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
    
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Spacer()
            AppSlogan()
            Spacer()
            VStack {
                if #available(iOS 17.0, *) {
                    UserInputCellView(text: $signUpId, title: "이메일", symbol: "envelope")
                        .onChange(of: signUpId, {
                            activeSignUpButton()
                        })
                    
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
                        .onChange(of: signUpPw1, {
                            activeSignUpButton()
                        })
                    UserInputCellView(text: $signUpPw2, title: "비밀번호 확인", symbol: "lock", isPassword: true)
                        .onChange(of: signUpPw2, {
                            activeSignUpButton()
                        })
                    
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
                } else {
                    UserInputCellView(text: $signUpId, title: "이메일", symbol: "envelope")
                        .onChange(of: signUpId, perform: { value in
                            activeSignUpButton()
                        })
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
                        .onChange(of: signUpPw1, perform: { value in
                            activeSignUpButton()
                        })
                    UserInputCellView(text: $signUpPw2, title: "비밀번호 확인", symbol: "lock", isPassword: true)
                        .onChange(of: signUpPw2, perform: { value in
                            activeSignUpButton()
                        })
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
                }
            }
            Spacer()
            
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
            
            // MARK: 회원가입 버튼
            if #available(iOS 17.0, *) {
                GeneralButton("회원가입", isDisabled: !isSignUpButtonActive) {
                    register()
                }
                .onChange(of: selectAgree) {
                    activeSignUpButton()
                }
                .navigationDestination(isPresented: $showProfile) {
                    SetProfileView(emailField: signUpId, registeredUID: $registeredUID)
                }
            } else {
                GeneralButton("회원가입", isDisabled: !isSignUpButtonActive) {
                    register()
                }
                .onChange(of: selectAgree, perform: { value in
                    activeSignUpButton()
                })
                .navigationDestination(isPresented: $showProfile) {
                    SetProfileView(emailField: signUpId, registeredUID: $registeredUID)
                }
            }
            
            Spacer()
            HStack(alignment: .center) {
                Text("이미 계정이 있으신가요?")
                Button {
                    dismiss()
                } label: {
                    Text("로그인")
                        .foregroundStyle(Color.pointColor)
                }
            }
            .font(.subheadline)
            Spacer()
        }
        .padding(20)
        .toolbarRole(.editor)
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
        Task {
            do {
                let register = try await authService.register(email: signUpId, password: signUpPw1)
                Configs.printDebugMessage("회원가입 성공, 생성된 계정 uid: \(register.user.uid)")
                registeredUID = register.user.uid
                showProfile.toggle()
            } catch {
                Configs.printDebugMessage("에러: \(error)")
            }
        }
    }
}

#Preview {
    SignUpView()
}