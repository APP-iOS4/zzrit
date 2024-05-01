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
    @EnvironmentObject private var loadRoomViewModel: LoadRoomViewModel
    @EnvironmentObject private var locationService: LocationService
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel
    
    // 우측 상단 알람 버튼 눌렀는지 안눌렀는지 검사
    @State private var isTopTrailingAction: Bool = false
    @State private var isOnline = false
    // 모임개설 FullScreenCover로 넘어가는지 결정하는 변수
    @State private var isShowingCreateRoom: Bool = false
    // 로그인 FullScreenCover로 넘어가는지 결정하는 변수
    @State private var isShowingLoginView: Bool = false
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    private var isLogined: Bool {
        return userService.loginedUser != nil
    }
    
    // MARK: - body
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView(.vertical) {
                    MainLocationView(isOnline: $isOnline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)

                    LazyVStack(alignment: .leading) {
                        // 마감 임박 타이틀
                        Text("인원 마감 임박")
                            .modifier(SubTitleModifier())
                    }
                    
                    // 모임 카트 뷰 리스트 불러오기
                    // TODO: 모델 연동 시 모임 마감 인원 모델 배열을 넘겨줘야 한다.
                    RoomCardListView(isManyPeopleCard: true)
                    
                    // 최근 생성된 모임 리스트 불러오기
                    // TODO: 모델 연동 시 최근 생성된 모임 모델 배열을 넘겨줘야 한다.
                    MainExistView(isOnline: $isOnline)
                }
                .padding(.vertical, 1)
                .refreshable {
                    loadRoomViewModel.refreshRooms(isOnline: isOnline)
                }
                
                // 모임개설 페이지로 이동하는 버튼
                createRoomButton
            }
            .toolbar {
                // 왼쪽 앱 메인 로고
                ToolbarItem(placement: .topBarLeading) {
                    NavigationSloganView()
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
            locationService.setCurrentLocation(LocalStorage.shared.latestSettedLocation() ?? .initialLocation)
        }
        .customOnChange(of: locationService.currentOffineLocation) { _ in
            loadRoomViewModel.refreshRooms(isOnline: isOnline)
            Configs.printDebugMessage("뭔가 바뀌긴 했어.")
        }
    }
}

extension MainView {
    private var createRoomButton: some View {
        Button {
            if isLogined {
                isShowingCreateRoom.toggle()
            } else {
                isShowingLoginView.toggle()
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
        .fullScreenCover(isPresented: $isShowingCreateRoom) {
            RoomCreateView()
        }
        .sheet(isPresented: $isShowingLoginView) {
        } content: {
            LogInView(loginToggleValue: $isShowingLoginView)
        }
    }
}

#Preview {
    NavigationStack {
        MainView()
            .environmentObject(UserService())
            .environmentObject(LoadRoomViewModel())
            .environmentObject(LocationService())
            .environmentObject(PurchaseViewModel())
    }
}
