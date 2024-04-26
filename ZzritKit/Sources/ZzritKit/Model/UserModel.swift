//
//  File.swift
//  
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

import FirebaseFirestore

/// 유저 모델
@available(iOS 16.0.0, *)
public struct UserModel: Codable, Identifiable {
    /// 유저의 FirebaseAuth의 uid
    @DocumentID public var id: String?
    /// 유저 이메일주소
    public var userID: String
    /// 유저 닉네임
    public var userName: String
    /// 유저 프로필사진 이미지 URL String
    public var userImage: String
    /// 유저의 성별
    public var gender: GenderType
    /// 유저의 출생년도
    public var birthYear: Int
    /// 유저의 정전기 지수
    public var staticGauge: Double
    /// 회원 탈퇴 일자
    public var secessionDate: Date?
    /// 유저가 참여한 모임 목록
    public var joinedRooms: [String]?
    /// 유저가 동의한 서비스 이용약관 시행 날짜
    /// - Warning: 동의를 한 날짜가 아닌, 시행날짜 입니다.
    public var agreeServiceDate: Date?
    /// 유저가 동의한 개인정보 처리방침 시행 날짜
    /// - Warning: 동의를 한 날짜가 아닌, 시행날짜 입니다.
    public var agreePrivacyDate: Date?
    /// 유저가 동의한 위치서비스 이용약관 시행 날짜
    /// - Warning: 동의를 한 날짜가 아닌, 시행날짜 입니다.
    public var agreeLocationDate: Date?
    /// 유저 디바이스 토큰
    public var pushToken: String?
    
    public init(id: String? = UUID().uuidString, userID: String, userName: String, userImage: String, gender: GenderType, birthYear: Int, staticGauge: Double, joinedRooms: [String]? = nil, agreeServiceDate: Date?, agreePrivacyDate: Date?, agreeLocationDate: Date?) {
        self.id = id
        self.userID = userID
        self.userName = userName
        self.userImage = userImage
        self.gender = gender
        self.birthYear = birthYear
        self.staticGauge = staticGauge
        self.joinedRooms = joinedRooms
        self.agreeServiceDate = agreeServiceDate
        self.agreePrivacyDate = agreePrivacyDate
        self.agreeLocationDate = agreeLocationDate
    }
    
    // FIXME: 프로필 이미지 비어있을 경우 보일 이미지 URL 추가 (25 line)
    
    public var profileImage: URL? {
        URL(string: userImage)
    }
    
    // FIXME: 밴 목록 불러오는 코드 추가
    
    public var bannedHistory: [BannedModel]? {
        return nil
    }
}
