//
//  ChatListView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/10/24.
//

import SwiftUI

struct ChatActiveListView: View {
    
    //MARK: - body
    
    var body: some View {
        List (0...3, id: \.self) { _ in
            ZStack {
                // 리스트로 보여줄 셀을 ZStack으로 감싼다.
                ChatListCellView()
                
                NavigationLink {
                    // 상세 페이지
                    // FIXME: 아직 채팅창 뷰는 미구현, 구현 되는 대로 뷰와 모델 연동
                    ChatView(isActive: true)
                } label: {
                    // 여기는 쓰이지 않는다
                }
                .opacity(0.0)
            }
        }
        .listStyle(.plain)
    }
}

//MARK: - List 오류 시 ScrollView로 변경
//        ScrollView {
//            LazyVStack {
//                ForEach (0...3, id: \.self) { _ in
//                    NavigationLink {
//                        // 상세 페이지
//                        // FIXME: 아직 채팅창 뷰는 미구현, 구현 되는 대로 뷰와 모델 연동
//                        Text("활성화 된 채팅창 뷰 입니다.")
//                    } label: {
//                        // 리스트에 보여줄 셀들
//                        // FIXME: 모델 연동 시, 모델 받는 것으로 수정해야 함
//                        ChatListCellView()
//                            .padding(.bottom, Configs.paddingValue)
//                    }
//                }
//            }
//        }

#Preview {
    NavigationStack {
        ChatActiveListView()
    }
}
