//
//  ChatDeactiveListView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/10/24.
//

import SwiftUI

struct ChatDeactiveListView: View {
    //MARK: - body
    
    var body: some View {
        List (0...3, id: \.self) { _ in
            ZStack {
                // 리스트로 보여줄 셀을 ZStack으로 감싼다.
                ChatListCellView()
                
                NavigationLink {
                    // 상세 페이지
                    // FIXME: 아직 채팅창 뷰는 미구현, 구현 되는 대로 뷰와 모델 연동
                    Text("비활성화 된 채팅창 뷰 입니다.")
                } label: {
                    // 여기는 쓰이지 않는다
                }
                //NavigationLink라벨을 가려야 Chevron이 없어진다
                .opacity(0.0)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    ChatDeactiveListView()
}
