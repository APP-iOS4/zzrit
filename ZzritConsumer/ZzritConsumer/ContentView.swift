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
    @StateObject private var notificationViewModel = NotificationViewModel.shared
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
            .customOnChange(of: notificationViewModel.notificationData) { data in
                Configs.printDebugMessage("notificationViewModel.notificationData 변경: \(notificationViewModel.notificationData)")
                guard let data else { return }
                
                let type = data.keys.first!
                let targetID = data.values.first!
                
                let tabIndex: Int
                let notiName: Notification.Name
                
                switch type {
                case .notice:
                    tabIndex = 3
                case .chat:
                    tabIndex = 2
                case .contact:
                    tabIndex = 3
                case .room:
                    tabIndex = 0
                case .banned:
                    tabIndex = 0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    tabSelection = tabIndex
                    notificationViewModel.clearAction()
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
