//
//  TermType.swift
//
//
//  Created by Sanghyeon Park on 4/13/24.
//

import Foundation

public enum TermType: String, Codable, CaseIterable {
    case service
    case privacy
    case location
    
    public var title: String {
        switch self {
        case .service:
            return "서비스 이용약관"
        case .privacy:
            return "개인정보 처리방침"
        case .location:
            return "위치서비스 이용약관"
        }
    }
}
