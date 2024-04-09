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
    
    public init(userID: String = UUID().uuidString) {
        self.userID = userID
    }
}
