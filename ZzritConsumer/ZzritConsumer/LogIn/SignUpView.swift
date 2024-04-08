//
//  SignUpView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/8/24.
//

import SwiftUI

struct SignUpView: View {
    
    @State var signUpId: String = ""
    @State var signUpPw1: String = ""
    @State var signUpPw2: String = ""
    @State var agreeSheet = false
    @State var selectAgree = false
    @State var equlText = false
    @State var isSignUpButtonActive: Bool = false

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
                    if checkEmail(signUpId){
                        Text("")
                    } else {
                        Text("이메일 형식이 올바르지 않습니다.")
                            .font(.subheadline)
                            .foregroundStyle(Color.red)
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
                            Text("비밀번호 입력란은 모두 채워주세요.")
                                .font(.subheadline)
                                .foregroundStyle(Color.red)
                        } else {
                            Text("비밀번호가 일치하지 않습니다.")
                                .font(.subheadline)
                                .foregroundStyle(Color.red)
                        }
                    }else {
                        Text("")
                            .font(.subheadline)
                    }
                } else {
                    UserInputCellView(text: $signUpId, title: "이메일", symbol: "envelope")
                        .onChange(of: signUpId, perform: { value in
                            activeSignUpButton()
                        })
                    if checkEmail(signUpId){
                        Text("")
                    } else {
                        Text("이메일 형식이 올바르지 않습니다.")
                            .font(.subheadline)
                            .foregroundStyle(Color.red)
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
                            Text("비밀번호 입력란을 모두 채워주세요.")
                                .font(.subheadline)
                                .foregroundStyle(Color.red)
                        } else {
                            Text("비밀번호가 일치하지 않습니다.")
                                .font(.subheadline)
                                .foregroundStyle(Color.red)
                        }
                    }else {
                        Text("")
                            .font(.subheadline)
                    }
                }
            }
            Spacer()
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
                GeneralButton(isDisabled: !isSignUpButtonActive, "회원가입" ) {
                    
                }
                .onChange(of: selectAgree) { 
                    activeSignUpButton()
                }
            } else {
                GeneralButton(isDisabled: !isSignUpButtonActive, "회원가입" ) {
                    
                }
                .onChange(of: selectAgree, perform: { value in
                    activeSignUpButton()
                })
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
                    isSignUpButtonActive = true
                }
            }
        } else {
            isSignUpButtonActive = false
        }
    }
    func checkEmail( _ str: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return  NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: str)
    }
}

struct SignUpAgreeButton: View {
    @Binding var selectAgree: Bool
    var body: some View {
        HStack {
            if selectAgree{
                Image(systemName: "checkmark.circle")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.pointColor)
            } else{
                Image(systemName: "circle")
            }
            Text("서비스 이용약관 동의")
            Spacer()
            Text("보기")
                .underline()
        }
        .foregroundStyle(Color.staticGray2)
    }
    
}

#Preview {
    SignUpView()
}
