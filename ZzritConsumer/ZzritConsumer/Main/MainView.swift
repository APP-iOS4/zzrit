//
//  MainView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/8/24.
//

import SwiftUI

struct MainView: View {
    // 플로팅 버튼을 눌렀는지 안 눌렀는지 검사
    @State private var isFloatingAction: Bool = false
    // 우측 상단 알람 버튼 눌렀는지 안눌렀는지 검사
    @State private var isTopTrailingAction: Bool = false
    
    // MARK: - body
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading) {
                        // 마감 임박 타이틀
                        Text("인원 마감 임박")
                            .modifier(SubTitleModifier())
                    }
                    .padding(.top, 20)
                    
                    // 모임 카트 뷰 리스트 불러오기
                    // TODO: 모델 연동 시 모임 마감 인원 모델 배열을 넘겨줘야 한다.
                    RoomCardListView()
                    
                    // 최근 생성된 모임 리스트 불러오기
                    // TODO: 모델 연동 시 최근 생성된 모임 모델 배열을 넘겨줘야 한다.
                    MainExistView()
                }
                .padding(.vertical, 1)
                
                // 방 생성 플로팅 버튼
                Button {
                    isFloatingAction.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(10)
                        .background(Color.pointColor)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.4), radius: 3)
                }
                .padding(20)
                // 방 생성뷰로 이동하는 navigationDestination
                .navigationDestination(isPresented: $isFloatingAction) {
                    Text("방 생성뷰")
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
                            isTopTrailingAction.toggle()
                        } label: {
                            Image(systemName: "bell")
                                .foregroundStyle(.black)
                        }
                        // 알람 뷰로 이동하는 navigationDestination
                        .navigationDestination(isPresented: $isTopTrailingAction) {
                            Text("알람 뷰")
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        MainView()
    }
}
