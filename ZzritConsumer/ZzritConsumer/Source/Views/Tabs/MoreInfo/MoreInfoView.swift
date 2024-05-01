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
    @State private var isShowingSecessionView: Bool = false
//    @State private var userService.loginedUser: UserModel? = nil
    @State private var userEmail: String?
    
    // 로그인 상태 일때 true
    private var isLogined: Bool {
        return userService.loginedUser != nil
    }
    
    var body: some View {
        NavigationStack {
            AdView()
            
            ScrollView {
                Section {
                    if isLogined {
                        
                        RoomCountView()
                            .padding([.horizontal, .bottom])
                        
                        ProfileInfoView()
                            .padding()
                        
                        MyStaticGaugeView(staticPoint: userService.loginedUser!.staticGauge)
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
                        .padding(.bottom, Configs.paddingValue)
                    }
                    
                    // 최근 본 모임
                    RecentWatchRoomView()
                    
                    // 그외 더보기 List
                    MoreInfoListView(loginedInfo: $userService.loginedUser, isLogined: isLogined)
                    if isLogined {
                        HStack {
                            Button {
                                isShowingSecessionView.toggle()
                            } label: {
                                Text("회원탈퇴")
                                    .font(.body)
                                    .padding()
                            }
                            .tint(Color.staticGray3)
                            .offset(x: 3)
                            
                            Spacer()
                        }
                        .fullScreenCover(isPresented: $isShowingSecessionView, onDismiss: fetchLogin) {
                            SecessionView()
                        }
                    }
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
            LogInView(loginToggleValue: $isShowingLoginView)
        }
        .onAppear {
            fetchLogin()
            Configs.printDebugMessage("onAppear")
        }
    }
    
    private func fetchLogin() {
        Task {
            do {
                userService.loginedUser = try await userService.loggedInUserInfo()
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
            .environmentObject(ContactService())
            .environmentObject(RecentRoomViewModel())
            .environmentObject(RestrictionViewModel())
            .environmentObject(LoadRoomViewModel())
            .environmentObject(LastChatModel())
            .environmentObject(NetworkMonitor())
            .environmentObject(PurchaseViewModel())
            .environmentObject(UserDefaultsClient())
    }
}
