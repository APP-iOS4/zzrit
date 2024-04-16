//
//  RoomCreateSubTitle.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

struct ArchieveRCSubtitle: View {
    // 부제목 변수
    let title: String
    // 추가 설명
    let clarification: String?
    // 부제목 타입
    let type: SubTitleType
    
    init(_ title: String, clarification: String? = nil, type: SubTitleType = .none) {
        self.title = title
        self.clarification = clarification
        self.type = type
    }
    
    var body: some View {
        VStack(spacing: 5.0) {
            HStack {
                Text(title)
                    .foregroundStyle(Color.staticGray1)
                    .fontWeight(.semibold)
                
                if type != .coverPhoto {
                    if let clarification {
                        Text("(\(clarification))")
                            .foregroundStyle(type == .none ? Color.staticGray3 : Color.pointColor)
                            .fontWeight(type == .none ? nil : .semibold)
                    }
                }
                
                Spacer()
            }
            
            if type == .coverPhoto {
                if let clarification {
                    HStack {
                        Text("* \(clarification)")
                            .foregroundStyle(Color.staticGray3)
                            .font(.footnote)
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    enum SubTitleType {
        case none
        case coverPhoto
        case staticGauge
    }
}

#Preview {
    ArchieveRCSubtitle("정원", clarification: "2~10명", type: .coverPhoto)
}
