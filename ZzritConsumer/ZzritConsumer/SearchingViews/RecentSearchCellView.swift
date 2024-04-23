//
//  RecentSearchCellView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

/// 최근 검색어 셀 뷰
/// - Parameters:
///     - context: 최근 검색어 내용
struct RecentSearchCellView: View {
    // 최근 검색어 내용
    var context: String
    
    var body: some View {
        Button {
            Configs.printDebugMessage("검색 기록 \(context) 검색")
        } label: {
            HStack(spacing: 20.0) {
                Image(systemName: "magnifyingglass.circle.fill")
                    .foregroundStyle(Color.pointColor)
                
                Text(context)
                    .lineLimit(1)
                
                Spacer()
                
                Button {
                    Configs.printDebugMessage("검색 기록 \(context) 삭제")
                } label: {
                    Text("X")
                }
                .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    RecentSearchCellView(context: "디자인")
}
