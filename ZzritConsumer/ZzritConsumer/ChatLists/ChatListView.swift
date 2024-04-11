//
//  ChatListView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/10/24.
//

import SwiftUI

struct ChatListView: View {
    @State private var selection = "참여 중인 모임"
    
    //MARK: - body
    
    var body: some View {
        NavigationStack {
            VStack {
                ChatCategoryView(selection: $selection)
                // FIXME: 현재 뷰가 Active뷰, Deactive뷰 따로 있지만 모델 연동 시, 하나의 뷰로 이용할 것, 지금은 더미로 뷰를 두 개 생성
                if selection == "참여 중인 모임" {
                    ChatActiveListView()
                } else {
                    ChatDeactiveListView()
                }
                
            }
            .toolbar {
                // 왼쪽 어디 탭인지 알려주는 제목
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 0) {
                        Text("채팅")
                    }
                    .font(.title3)
                    .fontWeight(.black)
                }

// MARK: - 의논사항: 채팅 리스트에서 검색이 필요한가?
                
//                // 오른쪽 채팅 목록을 검색하는 버튼
//                ToolbarItem(placement: .topBarTrailing) {
//                    HStack(spacing: 0) {
//                        Button {
//                            
//                        } label: {
//                            Image(systemName: "magnifyingglass")
//                                .foregroundStyle(.black)
//                        }
//                    }
//                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        ChatListView()
    }
}
