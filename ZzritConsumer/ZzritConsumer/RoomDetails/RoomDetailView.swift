//
//  RoomDetailView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

struct RoomDetailView: View {
    
    // MARK: - body
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    // 상단 타이틀 Stack
                    HStack {
                        // 카테고리
                        RoomCategoryView("술벙")
                        
                        // 타이틀
                        Text("같이 모여서 가볍게 치맥하실 분 구해요!")
                            .lineLimit(1)
                            .font(.title3)
                    }
                    
                    // 썸네일 이미지
                    Image(.dummy)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
                    
                    // 세부 내용
                    Text("여기는 세부적인 내용이 들어가는 곳입니다. 주제와 관련된 내용을 작성해 주시기 바랍니다.")
                        .foregroundStyle(Color.staticGray1)
                    
                    // 위치, 시간, 참여 인원에 대한 정보를 나타내는 뷰
                    // TODO: 모임 모델 하나를 이 곳에 전달을 해주어야 함
                    RoomInfoView()
                    
                    Text("와우, 벌써 4명이나 모였어요.")
                        .font(.title3)
                        .fontWeight(.bold)
                    // 참여자의 정보를 나타내는 뷰
                    // TODO: 모임에 참석하는 유저 정보를 전달해주어야 함
                    ParticipantListView()
                }
                .padding(20)
            }
        }
        .toolbarRole(.editor)
    }
}

#Preview {
    RoomDetailView()
}
