//
//  MainView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/8/24.
//

import SwiftUI

struct MainExistView: View {
    var body: some View {
        VStack(alignment: .leading) {
            // 모임 리스트 타이틀
            Text("최근 생성된 모임")
                .font(.title3)
                .fontWeight(.bold)
            
            // 리스트 목록 (스크롤뷰 형태)
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(1...9, id: \.self) { _ in
                    RoomCellView()
                }
                .padding(.bottom, 15)
            }
        }
    }
}

#Preview {
    MainExistView()
}
