//
//  ProfileEditView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

struct ProfileEditView: View {
    @State var isEditAction = false
    @State var showLoginView = false
    
    var email: String?
    var loginInfo: String
    var isLogined: Bool
    var emailString: String {
        if let email {
            return email
        } else {
            return "이곳을 눌러 로그인을 해주세요"
        }
    }
    
    var body: some View {
        HStack {
            if isLogined {
                VStack(alignment: .leading) {
                    Text(emailString)
                        .font(.title3)
                        .foregroundStyle(Color.staticGray1)
                    //로그인 상태 표시 - 구글, 애플, 자체 계정
                    Text(loginInfo)
                        .font(.callout)
                        .foregroundStyle(Color.staticGray3)
                    
                }
                Spacer()
                Button {
                    
                    // TODO: 프로필 편집 화면 연결
                    
                    isEditAction.toggle()
                } label: {
                    Image(systemName: "pencil.line")
                        .fontWeight(.medium)
                        .foregroundStyle(Color.staticGray3)
                        .frame(width: 30)
                }
            } else {
                Button {
                    showLoginView.toggle()
                } label: {
                    Text(emailString)
                        .font(.body)
                        .foregroundStyle(Color.staticGray1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .fullScreenCover(isPresented: $showLoginView, content: {
                    ZStack {
                        LogInView()
                        VStack {
                            HStack {
                                Spacer()
                                Button {
                                    showLoginView.toggle()
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.title2)
                                        .foregroundStyle(Color.staticGray)
                                }
                            }
                            .padding(.trailing, Configs.paddingValue)
                            Spacer()
                        }
                    }
                })
            }
        }
        .padding(Configs.paddingValue)
        .frame(maxWidth: .infinity)
        .background(Color.staticGray6)
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    NavigationStack {
        MoreInfoView()
    }
}
