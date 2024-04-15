//
//  RoomCardListView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/8/24.
//

import SwiftUI

struct RoomCardListView: View {
    // 현재 선택된 카드 인덱스
    @State private var selectedIndex: Int = 0
    //
    @State private var scrollSelectedIndex: Int = 0
    // 임시 배열카운트 개수
    let testCount: Int = 4
    
    // MARK: - body
    
    var body: some View {
        if #available(iOS 17.0, *) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach (0 ... testCount, id: \.self) { count in
                        // 네비게이션 링크를 통한 카드 뷰 상세 페이지 이동
                        NavigationLink {
                            // 상세페이지 뷰 연결
                            RoomDetailView()
                        } label: {
                            // 라벨은 카드 뷰
                            RoomCardView(titleToHStackPadding: 75)
                                .padding(.leading, 10)
                        }
                    }
                }
                .scrollTargetLayout()
                .padding(.trailing, 10)
            }
            .scrollTargetBehavior(.viewAligned)
            .padding(.bottom, 20)
            
            // 몇 번째 인덱스인지 알려주는 인디케이터
//            HStack(spacing: 3) {
//                ForEach(0...testCount, id: \.self) { index in
//                    Circle()
//                        .frame(width: 8, height: 8)
//                        .foregroundStyle(index == selectedIndex ? .black : Color.staticGray3)
//                        .padding(.horizontal, 3)
//                }
//            }
//            .padding(.bottom, 20)
        } else {
            // 카드 탭 뷰
            LazyVStack {
                TabView(selection: $selectedIndex) {
                    ForEach (0...testCount, id: \.self) { _ in
                        // 네비게이션 링크를 통한 카드 뷰 상세 페이지 이동
                        NavigationLink {
                            // 상세페이지 뷰 연결
                            RoomDetailView()
                        } label: {
                            // 라벨은 카드 뷰
                            RoomCardView(titleToHStackPadding: 75)
                        }
                    }
                    .padding(.trailing, 5)
                    .padding(.horizontal, 20)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                .frame(maxWidth: .infinity, minHeight: 200)
            }
            .padding(.bottom, 10)
            
            // 몇 번째 인덱스인지 알려주는 인디케이터
            HStack(spacing: 3) {
                ForEach(0...testCount, id: \.self) { index in
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundStyle(index == selectedIndex ? .black : Color.staticGray3)
                        .padding(.horizontal, 3)
                }
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    RoomCardListView()
}
