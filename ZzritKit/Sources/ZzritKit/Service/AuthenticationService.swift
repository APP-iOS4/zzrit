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
    
    var firebaseConstants = FirebaseConstants()
    
    var handle: AuthStateDidChangeListenerHandle?
    
    var currentUID: String? = nil
    
    init() {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            Task {
                self.currentUID = user?.uid
            }
        }
    }
    
    /// 로그인
    public func loginUser(email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            throw error
        }
    }
    
    /// 로그아웃
    public func logout() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw error
        }
    }
    
    /// 비밀번호 재설정
    public func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw error
        }
    }
    
    /// 회원가입
    public func register(email: String, password: String) async throws -> AuthDataResult {
        do {
            // Firebase Authentication에 계정 등록
            return try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            throw error
        }
    }
}
