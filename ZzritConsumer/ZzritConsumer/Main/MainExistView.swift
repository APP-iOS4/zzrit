//
//  MainView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/8/24.
//

import SwiftUI

struct MainExistView: View {
    var body: some View {
        LazyVStack(alignment: .leading) {
            // 모임 리스트 타이틀
            Text("최근 생성된 모임")
                .padding(.horizontal, 20)
                .font(.title3)
                .fontWeight(.bold)
            
            ForEach(1...9, id: \.self) { _ in
                RoomCellView()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
        .padding(.bottom, 15)
    }
}

#Preview {
    MainExistView()
}
