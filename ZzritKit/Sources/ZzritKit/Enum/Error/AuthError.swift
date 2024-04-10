//
//  File.swift
//  
//
//  Created by Sanghyeon Park on 4/10/24.
//

import Foundation

public enum AuthError: Error {
    case noClientID
    case noRootVC
    case occurred
    case noUserInfo
    
    public var description: String {
        switch self {
        case .noClientID: "Firebase의 클라이언트ID를 찾을 수 없습니다."
        case .noRootVC: "RootViewController를 찾을 수 없습니다."
        case .occurred: "알 수 없는 오류가 발생했습니다. 다시 시도해주세요."
        case .noUserInfo: "유저 정보가 DB에 없습니다."
        }
    }
}
