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
        Messaging.messaging().delegate = self
        
        let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOption,
            completionHandler: {_, _ in })
        
        /// 원격 푸시 등록
        application.registerForRemoteNotifications()
        Configs.printDebugMessage("원격 푸시 등록")
        
        return true
    }
    
    // fcm 토큰이 등록 되었을 때
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // 푸시 터치
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        print("푸시 터치")
        return .newData
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        return [[.sound, .banner, .list]]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        let aps = userInfo["aps"] as? [String: AnyObject]
        
        if let data = aps?["data"] as? [String: AnyObject] {
            if let prefix = data.keys.first, let notificationType = NotificationType(rawValue: prefix) {
                guard let value = data.values.first as? String else { return }
                NotificationViewModel.shared.setAction(type: notificationType, targetID: value)
            }
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Configs.printDebugMessage("\(#function) didReceiveRegistrationToken")
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                if let uid = AuthenticationService.shared.currentUID {
                    Configs.printDebugMessage("토큰 저장")
                    PushService.shared.saveToken(uid, token: token)
                }
            }
        }
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
    @StateObject private var userDefaultsClient = UserDefaultsClient()
    
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
                .environmentObject(userDefaultsClient)
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
