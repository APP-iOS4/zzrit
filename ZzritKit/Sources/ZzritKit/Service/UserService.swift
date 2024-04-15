//
//  UserService.swift
//
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

import FirebaseFirestore

@available(iOS 16.0.0, *)
public final class UserService: ObservableObject {
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
    
    /// 모임 후 찌릿 멤버를 선정하여 정전기 지수를 높입니다.
    /// - Parameter userUIDs([String]): 정전기 지수를 높일 회원의 uid 배열
    public func applyEvaluation(userUIDs: [String]) async throws {
        try await loginedCheck()
        
        do {
            for uid in userUIDs {
                try await firebaseConst.userCollection.document(uid).updateData(["staticGauge": FieldValue.increment(1.0)])
            }
        } catch {
            throw error
        }
    }
    
    /// 최신 약관을 불러옵니다.
    /// - Parameter type(TermType): 약관의 타입
    /// - Returns TermModel
    /// - Important: 유저가 동의한 약관의 날짜와 최신 날짜의 정보와 같은지 확인하는 작업은 앱단에서 구현 부탁드립니다.
    /// - Important: 시행날짜가 미래인 경우는 가져오지 않습니다.
    public func term(type: TermType) async throws -> TermModel {
        let snapshot = try await firebaseConst.termCollection
            .whereField("type", isEqualTo: type.rawValue)
            .whereField("date", isLessThanOrEqualTo: Date.now)
            .order(by: "date", descending: true)
            .limit(to: 1)
            .getDocuments()
        
        if snapshot.documents.isEmpty {
            throw FirebaseErrorType.noDocument
        }
        
        return try snapshot.documents.first!.data(as: TermModel.self)
    }
    
    // MARK: - Private Methods
    
    /// 접속된 회원정보 삭제
    func deleteLoginedUserInfo() async throws {
        try await loginedCheck()
        
        let loginedUID = try await loginedUserInfo()!.id!
        try await firebaseConst.userCollection.document(loginedUID).delete()
    }
    
    /// 로그인 상태 검증
    func loginedCheck() async throws {
        guard let _ = authService.currentUID else {
            throw AuthError.notLogin
        }
        
        guard let _ = try await loginedUserInfo() else {
            throw AuthError.noUserInfo
        }
    }
    
    // MARK: - Admin Methods
    
    /// 현재 로그인 되어있는 관리자의 정보를 가져옵니다.
    /// - Returns: Optional(AdminModel)
    public func loginedAdminInfo() async throws -> AdminModel? {
        if let uid = authService.currentUID {
            return try await getAdminInfo(uid: uid)
        } else {
            return nil
        }
    }
    
    /// 관리자의 정보를 가져옵니다.
    /// - Parameter uid(String): FirebaseAuth 로그인정보의 uid
    /// - Returns: Optional(AdminModel)
    public func getAdminInfo(uid: String) async throws -> AdminModel? {
        // 유저 정보가 존재하지 않을 경우, 에러 throw
        let document = try await firebaseConst.adminCollection.document(uid).getDocument()
        if !document.exists {
            throw AuthError.noUserInfo
        }
        
        return try await firebaseConst.adminCollection.document(uid).getDocument(as: AdminModel.self)
    }
    
    /// 사용자의 정보를 저장합니다.
    /// - Parameter admin(String): FirebaseAuth 로그인정보의 uid
    /// - Parameter info(UserModel): 사용자의 정보가 담겨있는 모델
    public func setUserInfo(admin uid: String, info: AdminModel) throws {
        try firebaseConst.adminCollection.document(uid).setData(from: info, merge: true)
    }
    
    /// 약관 정보를 등록합니다.
    /// - Parameter term(TermModel): 약관 정보 모델
    public func addTerm(term: TermModel) throws {
        try firebaseConst.termCollection.addDocument(from: term)
    }
    
    /// 약관 정보를 불러옵니다.
    /// - Parameter type(TermType): 약관의 타입
    public func terms(type: TermType) async throws -> [TermModel] {
        let snapshot = try await firebaseConst.termCollection
            .whereField("type", isEqualTo: type.rawValue)
            .order(by: "date", descending: true)
            .getDocuments()
        
        if snapshot.isEmpty {
            throw FirebaseErrorType.noDocument
        }
        
        return try snapshot.documents.map { try $0.data(as: TermModel.self) }
    }
}
