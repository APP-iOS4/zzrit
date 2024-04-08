//
//  File.swift
//  
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

/// 이용정지 타입
public enum BannedType: String, CaseIterable, Codable {
    case abuse = "폭언/욕설 사용"
    case wrongRoom = "부적절한 모임 개설"
    case religin = "종교 권유"
    case gambling = "불법 도박 홍보"
    case obscenity = "음란성 모임 개설"
    case administrator = "기타 사유"
}
