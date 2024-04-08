//
//  File.swift
//  
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

import FirebaseFirestore

/// 유저 모델
public struct UserModel: Codable, Identifiable {
    @DocumentID public var id: String?
    public var userID: String
    public var userName: String
    public var userImage: String
    public var gender: GenderType
    public var birthYear: Int
    public var staticGuage: Double
    
    public init(id: String? = nil, userID: String, userName: String, userImage: String, gender: GenderType, birthYear: Int, staticGuage: Double) {
        self.id = id
        self.userID = userID
        self.userName = userName
        self.userImage = userImage
        self.gender = gender
        self.birthYear = birthYear
        self.staticGuage = staticGuage
    }
    
    // FIXME: 프로필 이미지 비어있을 경우 보일 이미지 URL 추가 (25 line)
    
    public var profileImage: URL {
        guard let url = URL(string: userImage) else { return URL(string: "")! }
        return url
    }
    
    // FIXME: 밴 목록 불러오는 코드 추가
    
    public var bannedHistory: [BannedModel]? {
        return nil
    }
}
