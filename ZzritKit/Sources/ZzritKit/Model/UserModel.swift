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
    @DocumentID public var id: String? = UUID().uuidString
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
    public var staticGuage: Double
    /// 회원 탈퇴 일자
    public var secessionDate: Date?
    
    public init(id: String? = UUID().uuidString, userID: String, userName: String, userImage: String, gender: GenderType, birthYear: Int, staticGuage: Double) {
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
    
    /// 회원탈퇴 처리중인지 반환
    /// - Returns: (Bool): true일 경우 회원탈퇴 처리중
    public func isSecession() async -> Bool {
        do {
            guard let _ = AuthenticationService.shared.currentUID else { return true }
            
            var userService: UserService? = UserService()
            if let loginedUserInfo = try await userService?.loginedUserInfo() {
                if let _ = loginedUserInfo.secessionDate {
                    userService = nil
                    return true
                } else {
                    userService = nil
                    return false
                }
            } else {
                
                // TODO: return -> throw 변경
                
                return false
            }
        } catch {
            print("에러: \(error)")
            return false
        }
    }
}
