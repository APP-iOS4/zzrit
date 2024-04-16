//
//  RCCustomNavigationView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/10/24.
//

import SwiftUI

struct ArchieveRCNaviBar: View {
    @Environment(\.dismiss) private var dismiss
    let page: RCPage
    
    var body: some View {
        VStack {
            ZStack {
                // 뒤로가기 버튼
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Label("뒤로", systemImage: "chevron.left")
                            .foregroundStyle(.black)
                            .labelStyle(.iconOnly)
                    }
                    Spacer()
                }
                
                // 네비게이션 타이틀
                HStack {
                    Text("모임개설")
                        .fontWeight(.semibold)
                }
            }
            
            // 인디케이터(Indicator)
            HStack {
                ForEach(RCPage.allCases, id: \.self) { index in
                    RoundedRectangle(cornerRadius: Configs.cornerRadius)
                        .fill(index.rawValue <= page.rawValue ? Color.pointColor : Color.staticGray6)
                        .frame(height: 4.0)
                }
            }
        }
    }
    
    enum RCPage: Int, CaseIterable {
        case first = 0
        case second = 1
        case third = 2
    }
}

#Preview {
    ArchieveRCNaviBar(page: .first)
}
