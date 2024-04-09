//
//  RecentSearchCellView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/8/24.
//

import SwiftUI

/// 최근 검색어 셀 뷰 - 폐기됨
/// - Parameters:
///     - context: 최근 검색어 내용
/// - 특이사항: 리스트로 변경됨. 나중에 태그 형식처럼 바꿔보는 게 좋을 듯 함.
struct ArchieveRecentSearchCell: View {
    // 최근 검색어 내용
    var context: String
    
    var body: some View {
        HStack(spacing: 10.0) {
            // 실제 검색 기록 텍스트
            Text(context)
                .foregroundStyle(Color.staticGray)
            
            // 검색 기록 삭제 버튼
            Button {
                // TODO: 검색 기록 배열에서 삭제 구현 필요
                print("검색 기록 - \(context) 삭제")
            } label: {
                Text("X")
                    .foregroundStyle(Color.staticGray)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: Configs.cornerRadius)
                .fill(Color.staticGray6)
        }
    }
}

#Preview {
    ArchieveRecentSearchCell(context: "디자인")
}
