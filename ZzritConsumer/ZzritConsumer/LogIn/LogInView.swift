//
//  LogInView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/8/24.
//

import SwiftUI
import ZzritKit

struct LogInView: View {
    
    @State var id: String = ""
    @State var pw: String = ""
    
    @State var pressSignUpButton: Bool = false
    @State var isLoginButtonActive: Bool = false
    @State var failLogIn = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // TODO: 로고 이미지 삽입
                Image("StaticLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                AppSlogan()
                
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
                Spacer()
                HStack {
                    Button(action: {
                        pressSignUpButton.toggle()
                    }, label: {
                        Text("회원가입")
                    })
                    .navigationDestination(isPresented: $pressSignUpButton) {
                        SignUpView()
                    }
                    
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Text("비밀번호를 잊으셨나요?")
                    })
                }
                .font(.subheadline)
                .foregroundColor(Color.pointColor)
                GeneralButton(isDisabled: !isLoginButtonActive, "로그인") {
                    // MARK: 실패시 failLogIn = true
                }
                if failLogIn {
                    Text("로그인 정보를 다시 확인해 주세요.")
                        .font(.subheadline)
                        .foregroundColor(Color.pointColor)
                } else {
                    Text("")
                        .font(.subheadline)
                }
                Spacer()
                // MARK: fake용 버튼
                HStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .foregroundStyle(.black)
                        Image(systemName: "apple.logo")
                            .font(.title)
                            .foregroundStyle(.white)
                    }
                    .frame(width: 50, height: 50)
                    ZStack {
                        AsyncImage(url: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png")){image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 45, height: 45)
                    }
                    .frame(width: 50, height: 50)
                    
                    ZStack {
                        Circle()
                            .foregroundStyle(.blue)
                        //Color(red: 23.14, green: 34.9, blue: 59.61)
                        Text("f")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                    }
                    .frame(width: 50, height: 50)
                    
                    AsyncImage(url: URL(string: "https://clova-phinf.pstatic.net/MjAxODAzMjlfOTIg/MDAxNTIyMjg3MzM3OTAy.WkiZikYhauL1hnpLWmCUBJvKjr6xnkmzP99rZPFXVwgg.mNH66A47eL0Mf8G34mPlwBFKP0nZBf2ZJn5D4Rvs8Vwg.PNG/image.png")){image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                }
            }
            .padding(20)
        }
    }
    func activeLoginButton() {
        if !id.isEmpty && !pw.isEmpty {
            isLoginButtonActive = true
        } else {
            isLoginButtonActive = false
        }
    }
    
}

#Preview {
    LogInView()
}
