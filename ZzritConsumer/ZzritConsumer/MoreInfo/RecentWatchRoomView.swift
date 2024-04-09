//
//  RecentWatchRoomView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

let tempCount = 5

struct RecentWatchRoomView: View {
    @State var selectedIndex = 0
    
    // 최근 본 모임 전체 뷰
    var body: some View {
        VStack(alignment: .leading) {
            Text("최근 본 모임")
                .font(.title3)
                .fontWeight(.bold)
            // 최근 본 모임 슬라이드
            VStack {
                TabView(selection: $selectedIndex) {
                    ForEach(0..<tempCount, id: \.self) { _ in
                        NavigationLink {
                            // 모임 상세 페이지 넘기기
                            RoomDetailView()
                        } label: {
                            RoomCardView(titleToHStackPadding: 25)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                .frame(maxWidth: .infinity, minHeight: 200)
                // TabView Indicator
                HStack {
                    ForEach(0..<tempCount, id: \.self) { index in
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundStyle(index == selectedIndex ? .black : Color.staticGray3)
                            .padding(.horizontal, 3)
                    }
                }
            }
        }
    }
}

#Preview {
    RecentWatchRoomView()
}
