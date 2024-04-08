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
    
    public func LoginedUserInfo() async throws -> UserModel? {
        if let uid = authService.currentUID {
            return try await getUserInfo(uid: uid)
        } else {
            return nil
        }
    }
    
    public func getUserInfo(uid: String) async throws -> UserModel? {
        return try await firebaseConst.userCollection.document(uid).getDocument(as: UserModel.self)
        
    }
    
    public func setUserInfo(uid: String, info: UserModel) throws {
        try firebaseConst.userCollection.document(uid).setData(from: info, merge: true)
    }
}
