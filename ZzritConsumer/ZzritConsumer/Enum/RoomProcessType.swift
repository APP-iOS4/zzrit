//
//  roomProcess.swift
//  StaticTemp
//
//  Created by 이선준 on 4/14/24.
//

import Foundation

// MARK: - 가져가야 함

enum RoomProcessType: String, CaseIterable, Equatable, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case offline = "대면(오프라인)"
    case online = "비대면(온라인)"
    
    var value: Bool {
        switch self {
        case .offline:
            false
        case .online:
            true
        }
    }
}
