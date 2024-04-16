//
//  FullScreenCover.swift
//  StaticTemp
//
//  Created by 이선준 on 4/13/24.
//

import SwiftUI

// MARK: - 가져가야 함

enum FullScreenCover: String, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case nothing = "아직 없음"
    
    @ViewBuilder
    func build() -> some View {
        switch self {
        case .nothing:
            EmptyView()
        }
    }
}

