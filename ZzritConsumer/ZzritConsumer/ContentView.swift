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
    
    var body: some View {
        TabView(selection: $tabSelection) {
            MainView()
                .tabItem { 
                    Label("모임", image: tabSelection == 0 ? "homefill" : "home")
                }
                .tag(0)
            
            SearchingView()
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
    }
}

#Preview {
    ContentView()
}
