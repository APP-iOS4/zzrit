//
//  AuthenticationService.swift
//
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

import FirebaseAuth

@available(iOS 16.0.0, *)
public final class AuthenticationService: ObservableObject {
    public static let shared = AuthenticationService()
    
    var firebaseConst = FirebaseConstants()
    
    var handle: AuthStateDidChangeListenerHandle?
    
    var currentUID: String? = nil
    
    init() {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            Task {
                self.currentUID = user?.uid
            }
        }
    }
    
    /// 이메일과 비밀번호로 로그인 합니다.
    /// - Parameter email(String): 이메일주소
    /// - Parameter password(String): 비밀번호
    /// - Warning: 로그인 성공을 제외한 모든 경우에는 에러를 throw합니다. 사용하는 부분에서 에러핸들링이 필요합니다.
    public func loginUser(email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
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
}
