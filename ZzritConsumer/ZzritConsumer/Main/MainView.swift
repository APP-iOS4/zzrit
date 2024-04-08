//
//  MainView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/8/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    // 마감 임박 타이틀
                    Text("인원 마감 임박")
                        .modifier(SubTitleModifier())
                }
                .padding(.top, 20)
                
                // 모임 카트 뷰 리스트 불러오기
                RoomCardListView()
                
                // 최근 생성된 모임 리스트 불러오기
                MainExistView()
            }
        }
        .toolbar {
            // 왼쪽 앱 메인 로고
            ToolbarItem(placement: .topBarLeading) {
                HStack(spacing: 0) {
                    Text("ZZ!RIT")
                }
                .font(.title2)
                .fontWeight(.black)
            }
            
            // 오른쪽 알림 창
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "bell")
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MainView()
    }
}
