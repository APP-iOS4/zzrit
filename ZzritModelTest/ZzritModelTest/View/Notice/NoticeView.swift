//
//  NoticeView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/9/24.
//

import SwiftUI

struct NoticeView: View {
    var body: some View {
        TabView {
            NoticeView()
                .tabItem {
                    Label("등록", systemImage: "pencil")
                }
        }
    }
}

#Preview {
    NoticeView()
}
