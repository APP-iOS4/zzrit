//
//  ZzritAdministratorApp.swift
//  ZzritAdministrator
//
//  Created by Sanghyeon Park on 4/8/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct ZzritAdministratorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // 공지 데이터 뷰 모델
    @StateObject private var noticeViewModel = NoticeViewModel()
    @StateObject private var termsViewModel = TermsViewModel()
    @StateObject private var contactViewModel = ContactViewModel()
    @StateObject private var roomViewModel = RoomViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environmentObject(noticeViewModel)
                .environmentObject(termsViewModel)
                .environmentObject(contactViewModel)
                .environmentObject(roomViewModel)
        }
    }
}
