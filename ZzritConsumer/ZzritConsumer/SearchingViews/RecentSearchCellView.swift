//
//  RecentSearchCellView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/8/24.
//

import SwiftUI
import ZzritKit

struct RecentSearchCellView: View {
    var context: String
    
    var body: some View {
            
        HStack(spacing: 10.0) {
            /// 실제 검색 기록 텍스트
            Text(context)
                .foregroundStyle(Color.staticGray)
            
            /// 검색 기록 삭제 버튼
            Button {
                // TODO: 검색 기록 배열에서 삭제 구현 필요
                print("검색 기록 - \(context) 삭제")
            } label: {
                Text("X")
                    .foregroundStyle(Color.staticGray)
            }
        }
        .padding()
        // .padding(.trailing, 15.0)
        .background {
            RoundedRectangle(cornerRadius: Configs.cornerRadius)
                .fill(Color.staticGray6)
        }
    }
}

#Preview {
    RecentSearchCellView(context: "디자인")
}
