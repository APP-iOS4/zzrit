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
    @State private var userModel: UserModel?
    
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
            .tint(Color.pointColor)
            .onAppear {
                Task {
                    userModel = try await userService.loggedInUserInfo()
                    if let id = userModel?.id{
                        restrictionViewModel.loadRestriction(userID: id)
                        print(restrictionViewModel.isUnderRestriction)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
