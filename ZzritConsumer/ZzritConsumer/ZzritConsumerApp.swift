//
//  ZzritConsumerApp.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/8/24.
//

import AppTrackingTransparency
import SwiftUI

import FirebaseCore
import GoogleMobileAds
import ZzritKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct ZzritConsumerApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var userService = UserService()
    @StateObject private var contactService = ContactService()
    @StateObject private var recentRoomViewModel = RecentRoomViewModel()
    @StateObject private var restrictionViewModel = RestrictionViewModel()
    @StateObject private var loadRoomViewModel = LoadRoomViewModel()
    @StateObject private var lastChatModel = LastChatModel()
    @StateObject private var networkMonitor = NetworkMonitor()
    @StateObject private var purchaseViewModel = PurchaseViewModel()
    
    @State private var userModel: UserModel?
    @State private var isState: Bool = false
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    let tabBarAppearance = UITabBarAppearance()
                    tabBarAppearance.configureWithTransparentBackground()
                    UITabBar.appearance().standardAppearance = tabBarAppearance
                    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                    
                    let navigationBarAppearance = UINavigationBarAppearance()
                    navigationBarAppearance.configureWithTransparentBackground()
                    UINavigationBar.appearance().standardAppearance = navigationBarAppearance
                    
                    fetchRestriction()
                }
                .customOnChange(of: scenePhase) { _ in
                    if scenePhase == .active {
                        fetchRestriction()
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    Task {
                        await ATTrackingManager.requestTrackingAuthorization()
                    }
                }
                .onAppear {
                    purchaseViewModel.startObservingTransactionUpdates()
                }
                .task {
                    await GADMobileAds.sharedInstance().start()
                    await ATTrackingManager.requestTrackingAuthorization()
                    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["51457a6e5688df33e1f59fe13619a62f"]
                }
                .preferredColorScheme(.light)
                .environmentObject(userService)
                .environmentObject(contactService)
                .environmentObject(recentRoomViewModel)
                .environmentObject(restrictionViewModel)
                .environmentObject(loadRoomViewModel)
                .environmentObject(lastChatModel)
                .environmentObject(networkMonitor)
                .environmentObject(purchaseViewModel)
        }
    }
    
    private func fetchRestriction() {
        Task {
            userModel = try await userService.loggedInUserInfo()
            if let id = userModel?.id{
                restrictionViewModel.loadRestriction(userID: id)
                print(restrictionViewModel.isUnderRestriction)
            }
        }
    }
}
