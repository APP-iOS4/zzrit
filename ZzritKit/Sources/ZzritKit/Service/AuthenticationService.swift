//
//  AuthenticationService.swift
//
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

import FirebaseAuth
import FirebaseCore
import GoogleSignIn

@available(iOS 16.0.0, *)
public final class AuthenticationService: ObservableObject {
    public static let shared = AuthenticationService()
    
    var firebaseConst = FirebaseConstants()
    var handle: AuthStateDidChangeListenerHandle?
    
    public var secessioningUID: String?
    public var secessionDate: Date? = nil
    
    public private(set) var currentUID: String? = nil
    
    public private(set) var currentUserEmail: String? = Auth.auth().currentUser?.email
    
    init() {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            Task {
                self.currentUID = user?.uid
            }
        }
    }
    
    // MARK: Public Methods
    
    /// 이메일과 비밀번호로 로그인 합니다.
    /// - Parameter email(String): 이메일주소
    /// - Parameter password(String): 비밀번호
    /// - Warning: 로그인 성공을 제외한 모든 경우에는 에러를 throw합니다. 사용하는 부분에서 에러핸들링이 필요합니다.
    /// - 로그인 과정에서 회원탈퇴 여부에 따른 계정 삭제 로직을 실행합니다.
    public func loginUser(email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            try await checkSecession()
        } catch {
            throw error
        }
    }
    
    /// 구글 아이디로 로그인합니다.
    /// - Warning: 구글 아이디로 로그인 이후에 회원정보가 DB에 없을 경우(가입직후), AuthError를 반환합니다.
    @MainActor public func loginWithGoogle() async throws {
        do {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                throw AuthError.noClientID
            }
            
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            guard let rootVC = scene?.windows.first?.rootViewController else {
                throw AuthError.noRootVC
            }
            
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
            let user = result.user
            
            guard let idToken = user.idToken?.tokenString else {
                throw AuthError.occurred
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            try await Auth.auth().signIn(with: credential)
            
            var userService: UserService? = UserService()
            let _ = try await userService?.loggedInUserInfo()
            userService = nil
            
            try await checkSecession()
        } catch {
            throw error
        }
    }
    
    /// 로그아웃
    /// - Warning: 로그아웃 성공을 제외한 모든 경우에는 에러를 throw합니다. 사용하는 부분에서 에러핸들링이 필요합니다.
    public func logout() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw error
        }
    }
    
    /// 이메일 주소로 비밀번호 재설정 링크를 발송합니다.
    /// - Parameter email(String): 이메일주소
    /// - Warning: 비밀번호 재설정 링크 발송 성공을 제외한 모든 경우에는 에러를 throw합니다. 사용하는 부분에서 에러핸들링이 필요합니다.
    public func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw error
        }
    }
    
    /// FirebaseAuth 회원가입
    /// - Parameter email(String): 이메일주소
    /// - Parameter password(String): 비밀번호
    /// - Warning: 회원가입 성공을 제외한 모든 경우에는 에러를 throw합니다. 사용하는 부분에서 에러핸들링이 필요합니다.
    public func register(email: String, password: String) async throws -> AuthDataResult {
        do {
            // Firebase Authentication에 계정 등록
            return try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            throw error
        }
    }
    
    // MARK: - Private Methods
    
    /// FirebaseAuth 계정삭제
    private func deleteAccount() async {
        let user = Auth.auth().currentUser
        
        do {
            try await user?.delete()
        } catch {
            print("에러: \(error)")
        }
    }
    
    /// 회원탈퇴 검증
    private func checkSecession() async throws {
        // 회원탈퇴 검증
        var userService: UserService? = UserService()
        if
            let userInfo = try await userService?.loggedInUserInfo(),
            let withdrawalDate = userInfo.secessionDate?.addDay(at: 7)
        {
            if withdrawalDate < Date() {
                print("회원탈퇴를 신청하였고, 회원탈퇴 철회 기간이 만료되어 계정을 삭제합니다")
                try await userService?.deleteLoginedUserInfo()
                await deleteAccount()
                try logout()
                userService = nil
                throw AuthError.occurred
            } else {
                secessionDate = userService?.loginedUser?.secessionDate
                secessioningUID = AuthenticationService.shared.currentUID ?? ""
                print("\(secessioningUID) 회원탈퇴를 신청하였고, 회원탈퇴 철회 기간이 만료되지 않았습니다.")
                try logout()
                throw AuthError.secessioning
            }
        }
    }
    
    // MARK: - Admin Methods
    
    /// 이메일과 비밀번호로 관리자 로그인 합니다.
    /// - Parameter email(String): 이메일주소
    /// - Parameter password(String): 비밀번호
    /// - Warning: 로그인 성공을 제외한 모든 경우에는 에러를 throw합니다. 사용하는 부분에서 에러핸들링이 필요합니다.
    public func loginAdmin(email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            throw error
        }
    }
}
