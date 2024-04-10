//
//  MoreInfoView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

struct MoreInfoView: View {
    // 우측 상단 설정 버튼 눌렀는지 안눌렀는지 검사
    @State private var isTopTrailingAction: Bool = false
    // 우측 상단 알람 버튼 눌렀는지 안눌렀는지 검사
    @State private var isTopLeadingAction: Bool = false
    // 현재 로그인 상태 -> 유 : email / 무 : nil
    @State var userEmail: String?
    // 로그인 상태 일때 true
    var isLogined: Bool {
        if userEmail != nil {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Section{
                    
                    // TODO: 유저 정보 입력
                    
                    ProfileEditView(email: userEmail, loginInfo: "네이버 로그인", isLogined: isLogined)
                        .padding()
                    
                    // 정전기 지수
                    if isLogined {
                        MyStaticGuageView()
                            .padding()
                    }
                    
                    // 최근 본 모임
                    RecentWatchRoomView()
                        .padding()
                    
                    // 그외 더보기 List
                    MoreInfoListView(isLogined: isLogined)
                }
            }
            .padding(.vertical, 1)
            .toolbar {
                // 왼쪽 앱 메인 로고
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 0) {
                        Text("더보기")
                    }
                    .font(.title2)
                }
                
                // 오른쪽 위 아이콘
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        //알림 버튼
                        Button {
                            isTopLeadingAction.toggle()
                        } label: {
                            Image(systemName: "bell")
                                .foregroundStyle(.black)
                        }
                        // 알람 뷰로 이동하는 navigationDestination
                        .navigationDestination(isPresented: $isTopLeadingAction) {
                            Text("알람 뷰")
                        }
                        //설정 버튼
                        Button {
                            isTopTrailingAction.toggle()
                        } label: {
                            Image(systemName: "gearshape")
                                .foregroundStyle(.black)
                        }
                        // 설정 뷰로 이동하는 navigationDestination
                        .navigationDestination(isPresented: $isTopTrailingAction) {
                            Text("설정 뷰")
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
        MoreInfoView()
    }
}
