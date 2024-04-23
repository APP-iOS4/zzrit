//
//  MainView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/8/24.
//

import SwiftUI

import ZzritKit

struct MainView: View {
    @EnvironmentObject private var userService: UserService
    
    // 우측 상단 알람 버튼 눌렀는지 안눌렀는지 검사
    @State private var isTopTrailingAction: Bool = false
    @State private var isOnline = false
    // 모임개설 FullScreenCover로 넘어가는지 결정하는 변수
    @State private var isShowingCreateRoom: Bool = false
    // 로그인이 안됐다면 로그인 Alert를 위한 변수
    @State private var alertToLogin: Bool = false
    // 로그인 FullScreenCover로 넘어가는지 결정하는 변수
    @State private var isShowingLoginView: Bool = false
    // 오프라인 위치
    @State private var offlineLocation: OfflineLocationModel? = nil
    
    // 유저모델 변수
    @State private var userModel: UserModel?
    private var isLogined: Bool {
        return userModel != nil
    }
    
    // MARK: - body
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView(.vertical) {
                    MainLocationView(isOnline: $isOnline, offlineLocation: $offlineLocation)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)

                    LazyVStack(alignment: .leading) {
                        // 마감 임박 타이틀
                        Text("인원 마감 임박")
                            .modifier(SubTitleModifier())
                    }
                    
                    // 모임 카트 뷰 리스트 불러오기
                    // TODO: 모델 연동 시 모임 마감 인원 모델 배열을 넘겨줘야 한다.
                    RoomCardListView()
                    
                    // 최근 생성된 모임 리스트 불러오기
                    // TODO: 모델 연동 시 최근 생성된 모임 모델 배열을 넘겨줘야 한다.
                    MainExistView(isOnline: $isOnline)
                }
                .padding(.vertical, 1)
                
                // 모임개설 페이지로 이동하는 버튼
                createRoomButton
            }
            .toolbar {
                // 왼쪽 앱 메인 로고
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 0) {
                        Text("ZZ!")
                            .foregroundStyle(Color.pointColor)
                        Text("RIT")
                    }
                    .font(.title2)
                    .fontWeight(.black)
                }
                
                // 오른쪽 알림 창
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button {
                            isTopTrailingAction.toggle()
                        } label: {
                            Image(systemName: "bell")
                                .foregroundStyle(.black)
                        }
                        // 알람 뷰로 이동하는 navigationDestination
                        .navigationDestination(isPresented: $isTopTrailingAction) {
                            Text("알람 뷰")
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task {
                userModel = try await userService.loggedInUserInfo()
            }
            offlineLocation = LocalStorage.shared.latestSettedLocation()
        }
    }
}

extension MainView {
    private var createRoomButton: some View {
        Button {
            if isLogined {
                isShowingCreateRoom.toggle()
            } else {
                alertToLogin.toggle()
            }
        } label: {
            Image(systemName: "plus")
                .font(.title)
                .fontWeight(.semibold)
                .padding(10)
                .background(Color.pointColor)
                .foregroundStyle(.white)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.4), radius: 3)
        }
        .padding(Configs.paddingValue)
        .alert("로그인 알림", isPresented: $alertToLogin) {
            // 로그인 시트 올리는 버튼
            Button {
                isShowingLoginView.toggle()
            } label: {
                Label("로그인", systemImage: "person.circle")
                    .labelStyle(.titleOnly)
            }
            // 취소 버튼
            Button{
                alertToLogin = false
            } label: {
                Label("취소", systemImage: "trash")
                    .labelStyle(.titleOnly)
            }
        } message: {
            Text("모임 개설을 위해서는 로그인이 필요합니다.")
        }
        .fullScreenCover(isPresented: $isShowingCreateRoom) {
            RoomCreateView()
        }
        .sheet(isPresented: $isShowingLoginView) {
            Task {
                userModel = try await userService.loggedInUserInfo()
            }
        } content: {
            LogInView()
        }
//        .fullScreenCover(isPresented: $isShowingLoginView) {
//            LogInView()
//        }
    }
}

#Preview {
    NavigationStack {
        MainView()
            .environmentObject(UserService())
    }
}
