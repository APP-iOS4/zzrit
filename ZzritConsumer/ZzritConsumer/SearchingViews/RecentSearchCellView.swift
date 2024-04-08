//
//  RecentSearchCellView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/8/24.
//

import SwiftUI

import ZzritKit

/// 최근 검색어 셀 뷰
/// - Parameters:
///     - context: 최근 검색어 내용
struct RecentSearchCellView: View {
    /// 최근 검색어 내용
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
        /// 피그마에서는 trailing에 좀 더 공백이 있는데, 안 이쁜거 같아서 주석처리 해놓음.
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
