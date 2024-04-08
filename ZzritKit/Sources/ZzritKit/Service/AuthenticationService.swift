//
//  AuthenticationService.swift
//
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

import FirebaseAuth

@available(iOS 16.0.0, *)
final class AuthenticationService: ObservableObject {
    static let shared = AuthenticationService()
    
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
    func loginUser(email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            throw error
        }
    }
    
    /// 로그아웃
    func logout() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw error
        }
    }
    
    /// 비밀번호 재설정
    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw error
        }
    }
    
    /// 회원가입
    func register(email: String, password: String) async throws {
        do {
            // Firebase Authentication에 계정 등록
            let _ = try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            throw error
        }
    }
}
