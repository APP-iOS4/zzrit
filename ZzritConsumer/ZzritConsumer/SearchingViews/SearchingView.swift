//
//  SearchingView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/8/24.
//

import SwiftUI

// TODO: 1. 텍스트 크기 조정 시 linelimit 처리하기?
// TODO: 2. 키보드 외 부분 눌렀을 때 키보드 내리기
// TODO: 3. 애니메이션 처리하기?

// 최근 검색 기록을 위한 임시 배열
let recentSearch: [String] = [
    "디자인",
    "모션 그래픽",
    "영어",
    "스터디",
    "영어 스터디",
    "영어 공부",
]

struct SearchingView: View {
    // 필터 열기 여부
    @State var isFilterShowing: Bool = false
    
    var body: some View {
        // 필터가 최근 검색어를 가렸을 경우, 필터가 눌려야 하므로 ZStack 사용
        ZStack {
            RecentSearchNavigationView()
            
            VStack {
                Spacer()
                
                Button {
                    isFilterShowing.toggle()
                } label: {
                    Label(isFilterShowing ? "필터 닫기" : "필터 열기",
                          systemImage: isFilterShowing ? "chevron.down" : "chevron.up"
                    )
                    .foregroundStyle(Color.staticGray2)
                }
                .padding(.bottom, isFilterShowing ? 15.0 : nil)
                
                if isFilterShowing {
                    SearchingFilterView()
                }
            }
        }
    }
}

#Preview {
    SearchingView()
}
