//
//  File 2.swift
//  
//
//  Created by woong on 4/8/24.
//

import Foundation

/// firebase에서 발생할 에러를 규정.
public enum FirebaseErrorType: Error {
    case unknown
    case firebase
    case failCreateRoom
    case failLoadRoom
    case mismatch
    case noMoreSearching
    case invalidPassword
    case errorEmailAlreadyInUse
    case noSignIn
    case noUserInfo
    case chatMessageEmpty
    case alreadyJoinedRoom
    case notJoinedRoom
    case failModifyingRoom
}
