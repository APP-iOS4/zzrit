//
//  Sheet.swift
//  StaticTemp
//
//  Created by 이선준 on 4/13/24.
//

import SwiftUI

// MARK: - 가져가야 함
enum Sheet: String, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case timeSetting = "시간 선택 페이지"
    case notification = "알림창"
    case searchOfflineLocation = "오프라인 장소 검색창"
    
    @ViewBuilder
    func build() -> some View {
        switch self {
        // 알림창 페이지
        case .notification:
            EmptyView()
        // 오프라인 위치 검색 페이지
        case .searchOfflineLocation:
            EmptyView()
        case .timeSetting:
            EmptyView()
        }
        // 시간 선택 페이지
    }
}
