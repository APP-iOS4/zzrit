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
    @DocumentID public var id: String?
    public var date: Date
    public var period: Date
    public var type: BannedType
}
