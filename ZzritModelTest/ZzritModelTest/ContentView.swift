//
//  ContentView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/8/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            NavigationLink("로그인") {
                LoginView()
            }
            NavigationLink("이미지 업로드") {
                ImageUploadView()
            }
            NavigationLink("찌릿 멤버 정전기 지수 올리기") {
                IncrementStaticGuageView()
            NavigationLink("공지사항") {
                NoticeView()
            }
            NavigationLink("모임관리") {
                RoomView()
            }
            NavigationLink("모임생성") {
                RoomCreateView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
