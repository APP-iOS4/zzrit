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
    var isSelected: Bool
    // 공지사항 Cell 라벨
    
    private var chevronImage: String {
        isSelected ? "chevron.up" : "chevron.down"
    }
    
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
                
                Image(systemName: chevronImage)
                    .animation(nil)
            }
            .padding(Configs.paddingValue)
        }
    }
}

#Preview {
    NoticeTitleView(title: "스태틱 새로운 공지사항 안내입니다.", date: "2024.01.31", isSelected: true)
}
