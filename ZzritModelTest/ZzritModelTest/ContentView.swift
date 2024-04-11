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
            NavigationLink("공지사항") {
                NoticeView()
            }
            NavigationLink("모임관리") {
                RoomView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
