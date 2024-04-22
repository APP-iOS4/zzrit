//
//  SocialLoginType.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/15/24.
//

import Foundation

enum SocialLoginType: String, CaseIterable {
    case google = "Google 계정으로 시작하기"
    
    var symbol: String {
        switch self {
        case .google:
            return "google"
        }
    }
}
