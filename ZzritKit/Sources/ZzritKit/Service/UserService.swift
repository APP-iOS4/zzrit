//
//  UserService.swift
//
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

import FirebaseFirestore

@available(iOS 16.0.0, *)
public final class UserService {
    private let firebaseConst = FirebaseConstants()
    private let authService = AuthenticationService.shared
    
    public init() { }
    
    // MARK: Public Methods
    
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
        // 유저 정보가 존재하지 않을 경우, 에러 throw
        let document = try await firebaseConst.userCollection.document(uid).getDocument()
        if !document.exists {
            throw AuthError.noUserInfo
        }
        
        return try await firebaseConst.userCollection.document(uid).getDocument(as: UserModel.self)
    }
    
    /// 사용자의 정보를 저장합니다.
    /// - Parameter uid(String): FirebaseAuth 로그인정보의 uid
    /// - Parameter info(UserModel): 사용자의 정보가 담겨있는 모델
    public func setUserInfo(uid: String, info: UserModel) throws {
        try firebaseConst.userCollection.document(uid).setData(from: info, merge: true)
    }
    
    /// 회원탈퇴
    public func secession() async throws {

        try await loginedCheck()
        
        do {
            var tempLoginedUserInfo = try await loginedUserInfo()!
            
            // 회원탈퇴가 이미 진행중일 경우 에러 throw
            if let _ = tempLoginedUserInfo.secessionDate {
                throw AuthError.secessioning
            }
            
            let loginedUID = tempLoginedUserInfo.id!
            print("UID: \(loginedUID)")
            tempLoginedUserInfo.secessionDate = Date()
//            try firebaseConst.userCollection.document(loginedUID).setData(from: tempLoginedUserInfo, merge: true)
            try await firebaseConst.userCollection.document(loginedUID).updateData(["secessionDate": Date()])
        } catch {
            throw error
        }
    }
    
    /// 회원탈퇴 철회
    public func secessionCancel() async throws {

        try await loginedCheck()
        
        do {
            var tempLoginedUserInfo = try await loginedUserInfo()!
            
            // 회원탈퇴가 진행중이지 않을때 에러 throw
            guard let _ = tempLoginedUserInfo.secessionDate else {
                print("회원탈퇴가 진행중이지 않음")
                return
            }
            
            let loginedUID = tempLoginedUserInfo.id!
            print("UID: \(loginedUID)")
            tempLoginedUserInfo.secessionDate = nil
            try await firebaseConst.userCollection.document(loginedUID).updateData(["secessionDate": FieldValue.delete()])
        } catch {
            throw error
        }
    }
    
    // MARK: - Private Methods
    
    /// 접송된 회원정보 삭제
    func deleteLoginedUserInfo() async throws {
        try await loginedCheck()
        
        let loginedUID = try await loginedUserInfo()!.id!
        try await firebaseConst.userCollection.document(loginedUID).delete()
    }
    
    /// 로그인 상태 검증
    private func loginedCheck() async throws {
        guard let _ = authService.currentUID else {
            throw AuthError.notLogin
        }
        
        guard let _ = try await loginedUserInfo() else {
            throw AuthError.noUserInfo
        }
    }
}
