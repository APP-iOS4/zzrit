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
    @State private var userModel: UserModel?
    @State private var isNetworkConnection: Bool = true
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
            .tint(Color.pointColor)
            .environmentObject(locationService)
            .customOnChange(of: networkMonitor.status) { status in
                if status == .satisfied {
                    isNetworkConnection = true
                } else {
                    isNetworkConnection = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
