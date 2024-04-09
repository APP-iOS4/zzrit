//
//  UserService.swift
//
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

@available(iOS 16.0.0, *)
public final class UserService {
    private let firebaseConst = FirebaseConstants()
    private let authService = AuthenticationService.shared
    
    public init() { }
    
    /// 현재 로그인 되어있는 사용자의 정보를 가져옵니다.
    /// - Returns: Optional(UserModel)
    public func loginedUserInfo() async throws -> UserModel? {
        if let uid = authService.currentUID {
            return try await getUserInfo(uid: uid)
        } else {
            return nil
        }
    }
    
    /// 사용자의 정보를 가져옵니다.
    /// - Parameter uid(String): FirebaseAuth 로그인정보의 uid
    /// - Returns: Optional(UserModel)
    public func getUserInfo(uid: String) async throws -> UserModel? {
        return try await firebaseConst.userCollection.document(uid).getDocument(as: UserModel.self)
    }
    
    /// 사용자의 정보를 저장합니다.
    /// - Parameter uid(String): FirebaseAuth 로그인정보의 uid
    /// - Parameter info(UserModel): 사용자의 정보가 담겨있는 모델
    public func setUserInfo(uid: String, info: UserModel) throws {
        try firebaseConst.userCollection.document(uid).setData(from: info, merge: true)
    }
}
