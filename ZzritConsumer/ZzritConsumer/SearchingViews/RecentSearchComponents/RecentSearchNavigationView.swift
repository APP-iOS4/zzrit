//
//  RecentSearchNavigationView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

struct RecentSearchNavigationView: View {
    var body: some View {
        NavigationStack {
            VStack {
                // 검색 필드 뷰
                SearchFieldView()
                
                HStack(alignment: .top) {
                    // 최근 검색어 타이틀
                    Text("최근 검색어")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // 최근 검색어 전체삭제 버튼
                    Button {
                        print("최근 검색어 전체삭제")
                    } label: {
                        Text("전체삭제")
                            .foregroundStyle(Color.staticGray2)
                    }
                }
                .padding()
                
                // 최근 검색어를 리스트 형태로 호출
                List {
                    ForEach(recentSearch, id: \.self) { history in
                        // 최근 검색어 셀 뷰 호출
                        RecentSearchCellView(context: history)
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    RecentSearchNavigationView()
}
