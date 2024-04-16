//
//  RoomCreateIndicator.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

struct ArchieveRCIndicator: View {
    let page: RoomCreatePage
    
    var body: some View {
        HStack {
            ForEach(RoomCreatePage.allCases, id: \.self) { index in
                RoundedRectangle(cornerRadius: Configs.cornerRadius)
                    .fill(index.rawValue <= page.rawValue ? Color.pointColor : Color.staticGray6)
                    .frame(height: 4.0)
            }
        }
    }
    
    enum RoomCreatePage: Int, CaseIterable {
        case first = 0
        case second = 1
        case third = 2
    }
}

#Preview {
    ArchieveRCIndicator(page: .second)
}
