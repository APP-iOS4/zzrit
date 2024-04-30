//
//  ContentView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/8/24.
//

import SwiftUI
import ZzritKit

struct ContentView: View {
    @State private var tabSelection: Int = 0
    @EnvironmentObject private var restrictionViewModel: RestrictionViewModel
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel
    @EnvironmentObject private var userDefaultsClient: UserDefaultsClient
    @State private var userModel: UserModel?
    @State private var isNetworkConnection: Bool = true
    @State private var showsOnboarding: Bool = false
    
    @StateObject private var locationService = LocationService.shared
    
    var body: some View {
        if restrictionViewModel.isUnderRestriction {
            UnderRestrictionView(userModel: $userModel)
                .tint(Color.pointColor)
        } else {
            TabView(selection: $tabSelection) {
                MainView()
                    .tabItem {
                        Label("모임", image: tabSelection == 0 ? "homefill" : "home")
                    }
                    .tag(0)
                NavigationStack {
                    SearchView()
                }
                .tabItem {
                    Label("탐색", image: "search")
                }
                .tag(1)
                
                ChatListView()
                    .tabItem {
                        Label("채팅", image: tabSelection == 2 ? "chatfill" : "chat")
                    }
                    .tag(2)
                
                MoreInfoView()
                    .tabItem {
                        Label("더보기", image: tabSelection == 3 ? "moreInfofill" : "moreInfo")
                    }
                    .tag(3)
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("didReceiveRemoteNotification"))) { notification in
                if let title = notification.userInfo?["title"] as? String{
                    // 임시구현 - 현재는 해당 탭으로만 이동하도록 설정
                    if title.contains("모임") {
                        tabSelection = 2
                    }
                }
            }
            .fullScreenCover(isPresented: .constant(!isNetworkConnection)) {
                if #available(iOS 16.4, *) {
                    NetworkConnectionWarnningView()
                        .presentationBackground(.regularMaterial)
                } else {
                    NetworkConnectionWarnningView()
                }
            }
            .sheet(isPresented: $purchaseViewModel.isPresent) {
                PurchaseView()
            }
            .tint(Color.pointColor)
            .environmentObject(locationService)
            .onAppear {
                guard userDefaultsClient.isOnBoardingDone else {
                    showsOnboarding = true
                    return
                }
            }
            .customOnChange(of: networkMonitor.status) { status in
                if status == .satisfied {
                    isNetworkConnection = true
                } else {
                    isNetworkConnection = false
                }
            }
            .fullScreenCover(isPresented: $showsOnboarding,
                   onDismiss: { userDefaultsClient.isOnBoardingDone = true }) {
                OnboardingView(isPresented: $showsOnboarding)
            }
        }
    }
}

#Preview {
    ContentView()
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
