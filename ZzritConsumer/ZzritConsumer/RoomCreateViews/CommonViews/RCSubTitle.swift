//
//  RCSubTitle.swift
//  StaticTemp
//
//  Created by 이선준 on 4/13/24.
//

import SwiftUI

struct RCSubTitle: View {
    // 부제목 변수
    let title: String
    // 추가 설명
    let clarification: String?
    // 부제목 타입
    let type: SubTitleType
    
    init(_ title: String, clarification: String? = nil, type: SubTitleType = .normal) {
        self.title = title
        self.clarification = clarification
        self.type = type
    }
    
    var body: some View {
        HStack {
            content()
            Spacer()
        }
    }
    
    @ViewBuilder
    func content() -> some View {
        switch type {
        // 일반적인 텍스트
        case .normal:
            HStack {
                Text(title)
                    .foregroundStyle(Color.staticGray1)
                    .fontWeight(.semibold)
                if let clarification {
                    Text("(\(clarification))")
                        .foregroundStyle(Color.staticGray3)
                }
            }
        // 상세 정보가 아래에 footnote로 표시됨
        case .detail:
            VStack(alignment: .leading, spacing: 5.0) {
                Text(title)
                    .foregroundStyle(Color.staticGray1)
                    .fontWeight(.semibold)
                if let clarification {
                    Text("* \(clarification)")
                        .foregroundStyle(Color.staticGray3)
                        .font(.footnote)
                }
            }
        // 상세 정보가 포인트 처리됨
        case .point:
            HStack {
                Text(title)
                    .foregroundStyle(Color.staticGray1)
                    .fontWeight(.semibold)
                if let clarification {
                    Text("(\(clarification))")
                        .foregroundStyle(Color.pointColor)
                        .fontWeight(.semibold)
                }
            }
        }
    }
    
    enum SubTitleType {
        /// 일반적인 부제목
        case normal
        /// 상세 정보가 아래에 footnote로 있는 부제목
        case detail
        /// 상세 정보가 포인트된 부제목
        case point
    }
}

#Preview {
    RCSubTitle("안녕하세요", clarification: "반값습니다.", type: .detail)
}
