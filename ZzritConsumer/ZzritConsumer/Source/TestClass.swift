//
//  TestClass.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/30/24.
//

import Foundation

@MainActor
class TestClass: ObservableObject {
    static let shared = TestClass()
    
    @Published var latestTitle: String = ""
    @Published var latestBody: String = ""
    @Published var latestDate: String = ""
    
    func setLatestMessage(title: String, body: String, date: String) {
        UserDefaults.standard.set(title, forKey: "latestTitle")
        UserDefaults.standard.set(body, forKey: "latestBody")
        UserDefaults.standard.set(date, forKey: "latestDate")
    }
    
    func syncLatestMessage() {
        latestTitle = UserDefaults.standard.string(forKey: "latestTitle") ?? ""
        latestBody = UserDefaults.standard.string(forKey: "latestBody") ?? ""
        latestBody = UserDefaults.standard.string(forKey: "latestDate") ?? ""
    }
}
