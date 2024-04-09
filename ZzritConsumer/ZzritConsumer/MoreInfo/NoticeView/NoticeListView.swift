//
//  NoticeListView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

let noticeCount = 10
struct NoticeListView: View {
    
    // count는 받아오는 공지사항의 개수
    // 공지 개수가 많아 진다면 [버튼ID: Bool]() 형식의 딕셔너리로 처리하는게 어떤지 ..
    @State private var showText = [Bool](repeating: false, count: noticeCount)
    
    var body: some View {
        NavigationStack{
            ScrollView {
                ForEach(0..<noticeCount, id: \.self) { toggle in
                    Button {
                        showText[toggle].toggle()
                    } label: {
                        // title: 공지 제목     date: 공지 날짜
                        NoticeTitleView(title: "내일은 마싯는 커피를 먹을 예정인 운영자", date: "2024.04.10")
                    }
                    if showText[toggle] {
                        // content: 공지 내용
                        NoticeContentView(content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.")
                    } else {
                        Divider()
                    }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("공지사항")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
    }
}

#Preview {
    NavigationStack{
        NoticeListView()
    }
}
