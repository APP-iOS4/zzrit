//
//  NoticeTitleView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

struct NoticeTitleView: View {
    var title: String
    var date: String
    var isOpen: Bool
    // 공지사항 Cell 라벨
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundStyle(Color.staticGray1)
                    Text(date)
                        .font(.callout)
                        .foregroundStyle(Color.staticGray3)
                }
                Spacer()
                if !isOpen {
                    Image(systemName: "chevron.down")
                } else {
                    Image(systemName: "chevron.up")
                }
            }
            .padding(Configs.paddingValue)
        }
    }
}

#Preview {
    NoticeTitleView(title: "스태틱 새로운 공지사항 안내입니다.", date: "2024.01.31", isOpen: true)
}
