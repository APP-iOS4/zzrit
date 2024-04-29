//
//  Configs.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/8/24.
//

import Foundation

struct Configs {
    static let cornerRadius: CGFloat = 10.0
    static let paddingValue: CGFloat = 20.0
    static let freeDailyCreateRoomCount: Int = 2
    
    
    static func printDebugMessage(_ content: Any) {
        #if DEBUG
            print(content)
        #endif
    }
}
