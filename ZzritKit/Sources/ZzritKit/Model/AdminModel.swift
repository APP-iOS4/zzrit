//
//  AdminModel.swift
//
//
//  Created by Sanghyeon Park on 4/11/24.
//

import Foundation

import FirebaseFirestore

/// 관리자 정보 모델
public struct AdminModel: Identifiable, Codable {
    @DocumentID public var id: String?
    /// 관리자 이름
    public var name: String
    /// 관리자 개인 이메일
    public var email: String
    /// 관리자 권한 등급
    public var level: AdminType
    
    public init(id: String? = nil, name: String, email: String, level: AdminType) {
        self.id = id
        self.name = name
        self.email = email
        self.level = level
    }
}
