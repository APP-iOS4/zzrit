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
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOption,
            completionHandler: {_, _ in })
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
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
    
    @State private var userModel: UserModel?
    
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

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        return [[.sound, .banner, .list]]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        // ...
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        print(userInfo)
    }
}

extension AppDelegate: MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Configs.printDebugMessage("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
