//
//  MoreInfoView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

import ZzritKit

struct MoreInfoView: View {
    @EnvironmentObject private var userService: UserService
    
    @State private var isShowingLoginView: Bool = false
    @State private var loginedInfo: UserModel? = nil
    @State private var userEmail: String?
    
    // 로그인 상태 일때 true
    private var isLogined: Bool {
        return loginedInfo != nil
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Section {
                    if isLogined {
                        ProfileInfoView(loginedInfo: loginedInfo!)
                            .padding()
                        
                        MyStaticGaugeView(staticPoint: loginedInfo!.staticGauge)
                            .padding()
                    } else {
                        Button {
                            isShowingLoginView.toggle()
                        } label: {
                            HStack {
                                GeneralButton("회원가입 / 로그인") {
                                    isShowingLoginView.toggle()
                                }
                            }
                            .padding(.horizontal, Configs.paddingValue)
                        }
                    }
                    
                    // 최근 본 모임
                    RecentWatchRoomView()
                    
                    // 그외 더보기 List
                    MoreInfoListView(loginedInfo: $loginedInfo, isLogined: isLogined)
                }
                .padding(.vertical, 10)
            }
            .padding(.vertical, 1)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 0) {
                        Text("더보기")
                    }
                    .font(.title3)
                    .fontWeight(.black)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .fullScreenCover(isPresented: $isShowingLoginView, onDismiss: fetchLogin) {
            LogInView()
        }
        .onAppear {
            fetchLogin()
            Configs.printDebugMessage("onAppear")
        }
    }
    
    private func fetchLogin() {
        Task {
            do {
                loginedInfo = try await userService.loginedUserInfo()
            } catch {
                Configs.printDebugMessage("에러: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        MoreInfoView()
            .environmentObject(UserService())
            .environmentObject(RecentRoomViewModel())
    }
}