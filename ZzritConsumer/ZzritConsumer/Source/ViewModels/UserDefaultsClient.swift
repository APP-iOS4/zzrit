//
//  UserDefaultsClient.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/28/24.
//

import Foundation
final class UserDefaultsClient: ObservableObject {
    @Published var isOnBoardingDone: Bool = UserDefaults.standard.bool(forKey: "isOnBoardingDone") {
        didSet {
            UserDefaults.standard.set(isOnBoardingDone, forKey: "isOnBoardingDone")
        }
    }
}
