//
//  File.swift
//  
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

/// 문의사항 카테고리 타입
public enum ContactCategory: String, CaseIterable, Codable {
    case app = "앱 이용 문의"
    case room = "모임/회원 신고"
}
