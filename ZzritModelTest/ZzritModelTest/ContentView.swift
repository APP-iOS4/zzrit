//
//  ContentView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/8/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                List {
                    NavigationLink("로그인") {
                        LoginView()
                    }
                    NavigationLink("이미지 업로드") {
                        ImageUploadView()
                    }
                    NavigationLink("찌릿 멤버 정전기 지수 올리기") {
                        IncrementStaticGaugeView()
                    }
                    NavigationLink("공지사항") {
                        NoticeView()
                    }
                    NavigationLink("모임관리") {
                        RoomView()
                    }
                    NavigationLink("모임생성") {
                        RoomCreateView()
                    }
                    NavigationLink("모임불러오기") {
                        RoomLoadView()
                    }
                    NavigationLink("Date <-> String 변환 뷰") {
                        DateNStringView()
                    }
                    NavigationLink("모임검색") {
                        RoomSearchView()
                    }
                    NavigationLink("푸시 메시지 발송") {
                        PushTestView()
                    }
                }
            }
            .tabItem {
                Label("소비자", systemImage: "cart")
            }
            
            AdminManageView()
                .tabItem {
                    Label("관리자", systemImage: "gearshape")
                }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
