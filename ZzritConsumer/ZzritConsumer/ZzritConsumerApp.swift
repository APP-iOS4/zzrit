//
//  ZzritConsumerApp.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/8/24.
//

import SwiftUI

@main
struct ZzritConsumerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: {
                    let tabBarAppearance = UITabBarAppearance()
                    tabBarAppearance.configureWithTransparentBackground()
                    UITabBar.appearance().standardAppearance = tabBarAppearance
                    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                    
                    let navigationBarAppearance = UINavigationBarAppearance()
                    navigationBarAppearance.configureWithTransparentBackground()
                    UINavigationBar.appearance().standardAppearance = navigationBarAppearance
                })
        }
    }
}
