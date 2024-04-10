//
//  ContentView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/8/24.
//

import SwiftUI
import ZzritKit

struct ContentView: View {
    var body: some View {
        // TODO: icon 선택시 fill로 
        TabView {
            MainView()
                .tabItem { Label("모임", image: "home") }
            
            SearchingView()
                .tabItem { Label("탐색", image: "search") }
            
            ChatListView()
                .tabItem { Label("채팅", image: "chat") }
            
            MoreInfoView()
                .tabItem { Label("더보기", image: "moreInfo") }
        }
        .tint(Color.pointColor)
        
    }
}

#Preview {
    ContentView()
}
