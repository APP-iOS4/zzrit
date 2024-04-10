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
        TabView {
            MainView()
                .tabItem { Label("모임", systemImage: "house.fill") }
            
            SearchingView()
                .tabItem { Label("탐색", systemImage: "magnifyingglass") }
            
            // TODO: 채팅 연결
            
//            ChattingView()
//                .tabItem { Label("채팅", systemImage: "ellipsis.bubble") }
            
            MoreInfoView()
                .tabItem { Label("더보기", systemImage: "ellipsis.circle") }
        }
        .tint(Color.pointColor)
        
    }
}

#Preview {
    ContentView()
}
