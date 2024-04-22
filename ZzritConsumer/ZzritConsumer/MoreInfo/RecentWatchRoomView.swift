//
//  RecentWatchRoomView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

import ZzritKit

let tempCount = 5

struct RecentWatchRoomView: View {
    @EnvironmentObject private var recentRoomViewModel: RecentRoomViewModel
    
    @State var selectedIndex = 0
    
    // 최근 본 모임 전체 뷰
    var body: some View {
        VStack(alignment: .leading) {
            Text("최근 본 모임")
                .font(.title3)
                .fontWeight(.bold)
                .offset(y: 30)
                .padding(.leading, 20)
            
            if !recentRoomViewModel.recentViewedRooms.isEmpty {
            // 최근 본 모임 슬라이드
            VStack {
                    TabView(selection: $selectedIndex) {
                        ForEach(recentRoomViewModel.recentViewedRooms.indices, id: \.self) { index in
                            NavigationLink {
                                // 모임 상세 페이지 넘기기
                                RoomDetailView(room: recentRoomViewModel.recentViewedRooms[index])
                            } label: {
                                RoomCardView(room: recentRoomViewModel.recentViewedRooms[index], titleToHStackPadding: 25)
                            }
                            .tag(index)
                        }
                        .frame(height: 150)
                        .padding(.horizontal, 20)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                    .frame(maxWidth: .infinity, minHeight: 200)
                    // TabView Indicator
                    HStack {
                        ForEach(recentRoomViewModel.recentViewedRooms.indices, id: \.self) { index in
                            Circle()
                                .frame(width: 8, height: 8)
                                .foregroundStyle(index == selectedIndex ? .black : Color.staticGray3)
                                .padding(.horizontal, 3)
                        }
                    }
                }
            } else {
                RoundedRectangle(cornerRadius: Configs.cornerRadius)
                    .fill(Color.clear)
                    .frame(height: 150)
                    .padding(.horizontal, 20)
                    .padding(.top, 25)
                    .overlay {
                        VStack(spacing: 0) {
                            Image(.zziritLogo)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                            
                            Text("최근 본 모임이 없어요")
                        }
                    }
            }
        }
    }
}

#Preview {
    RecentWatchRoomView()
        .environmentObject(RecentRoomViewModel())
}
