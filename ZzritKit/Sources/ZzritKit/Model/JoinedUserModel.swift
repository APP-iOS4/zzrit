//
//  File.swift
//  
//
//  Created by woong on 4/8/24.
//

import Foundation

import FirebaseFirestore

/// JoinedUser 모델
public struct JoinedUserModel: Codable {
    /// 현재 모임에 참여한 유저ID
    public var userID: String = UUID().uuidString
    /// 모임에 참여한 날짜 및 시간
    public var joinedDatetime: Date = Date()
    
    public init(userID: String = UUID().uuidString, joinedDatetime: Date = Date()) {
        self.userID = userID
        self.joinedDatetime = joinedDatetime
    }
}
