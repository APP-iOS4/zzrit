//
//  FetchError.swift
//
//
//  Created by Sanghyeon Park on 4/10/24.
//

import Foundation

public enum FetchError: Error {
    case noMoreFetch
    
    public var description: String {
        switch self {
        case .noMoreFetch: "더이상 불러올 데이터가 없습니다."
        }
    }
}
