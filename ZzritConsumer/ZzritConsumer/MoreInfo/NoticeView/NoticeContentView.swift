//
//  NoticeContentView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

struct NoticeContentView: View {
    var content: String
    // 공지사항 본문
    var body: some View {
        ZStack {
            Text(content)
                .foregroundStyle(Color.staticGray2)
                .padding(Configs.paddingValue)
        }
        .background(Color.staticGray5)
    }
}

#Preview {
    NoticeContentView(content: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.")
}
