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
                NavigationLink("로그인") {
                    LoginView()
                }
                NavigationLink("이미지 업로드") {
                    ImageUploadView()
                }
                NavigationLink("찌릿 멤버 정전기 지수 올리기") {
                    IncrementStaticGuageView()
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
