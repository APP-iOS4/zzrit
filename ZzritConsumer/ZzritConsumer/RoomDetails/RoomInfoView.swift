//
//  RoomInfoView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

struct RoomInfoView: View {
    var body: some View {
        VStack(alignment: .leading) {
            // 위치
            HStack {
                Text("위치")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.pointColor)
                
                // TODO: 모델 연동 시, 이곳에 위치 값을 넣기
                Text("서울시 종로구 (약 1.2km)")
                    .foregroundStyle(Color.staticGray1)
                
                Spacer()
            }
            .padding(.vertical, 5)
            
            // 시간
            HStack {
                Text("시간")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.pointColor)
                
                // TODO: 모델 연동 시, 이곳에 시간 값을 넣기
                Text("4월 11일 목요일 16:30 ~ 18:30")
                    .foregroundStyle(Color.staticGray1)
            }
            .padding(.vertical, 5)
            
            // 현재 참여 인원
            HStack {
                Text("참여인원")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.pointColor)
                
                // TODO: 모델 연동 시, 이곳에 참여인원, 제한인원 값 넣기
                Text("4 / 8")
                    .foregroundStyle(Color.staticGray1)
            }
            .padding(.vertical, 5)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .overlay {
            RoundedRectangle(cornerRadius: Configs.cornerRadius)
                .stroke(lineWidth: 1.0)
                .foregroundStyle(Color.staticGray4)
        }
    }
}

#Preview {
    RoomInfoView()
}
