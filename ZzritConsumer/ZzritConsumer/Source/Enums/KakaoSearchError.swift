//
//  KakaoSearchError.swift
//  API
//
//  Created by Sanghyeon Park on 2/28/24.
//

import Foundation

public enum KakaoSearchError: Error {
    case invalidUrl
    case invalidApiKey
    case serverError
    case clientError
    case redirection
    case unknowned
    case none
    
    public var errorDescription: String {
        switch self {
        case .invalidUrl:
            return "요청 URL이 올바르지 않습니다."
        case .invalidApiKey:
            return "API Key가 올바르지 않습니다."
        case .serverError:
            return "서버와의 통신이 원할하지 않습니다."
        case .clientError:
            return "잘못 된 요청입니다."
        case .redirection:
            return "리다이렉션 오류가 발생했습니다."
        case .unknowned:
            return "알 수 없는 오류가 발생했습니다."
        case .none:
            return ""
        }
    }
}
