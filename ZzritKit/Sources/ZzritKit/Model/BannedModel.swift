//
//  BannedModel.swift
//
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

import FirebaseFirestore

/// 이용정지 모델
public struct BannedModel: Codable, Identifiable {
    @DocumentID public var id: String? = UUID().uuidString
    /// 이용정지 시작 날짜
    public var date: Date
    /// 이용정지 만료 날짜
    public var period: Date
    /// 이용 정지 타입
    public var type: BannedType
}
