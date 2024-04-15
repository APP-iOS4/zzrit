//
//  File.swift
//  
//
//  Created by woong on 4/15/24.
//

import Foundation

@available(iOS 16.0, *)
public final class UserManageService {
    private let fbConstant = FirebaseConstants()
    private let authService = AuthenticationService.shared
    
    // TODO: 유저 제제 등록
    // 관리자id, 유저id
    public func registerUserRestriction(uid: UserModel.ID) {
        
    }
    
    // TODO: 유저 제재 삭제
    // 관리자id, 유저id
    
    // TODO: 유저 정전기 지수 수정
    // 관리자id?, 유저id
    
    // TODO: 유저 이메일 변경
    
    // TODO: 유저 계정 삭제
}
