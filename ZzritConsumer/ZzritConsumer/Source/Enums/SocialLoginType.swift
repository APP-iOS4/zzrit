//
//  SocialLoginType.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/15/24.
//

import Foundation

enum SocialLoginType: CaseIterable {
    case google
    
    var buttonString: String {
        switch self {
        case .google:
            "Google 계정으로 시작하기"
        }
    }
}
