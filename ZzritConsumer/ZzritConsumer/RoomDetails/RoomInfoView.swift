//
//  RoomInfoView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

struct RoomInfoView: View {
    var body: some View {
        HStack {
            // 위치
            VStack(alignment: .leading) {
                Text("위치")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.pointColor)
                    .padding(.bottom, 5)
                
                Text("시간")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.pointColor)
                    .padding(.bottom, 5)
                
                Text("참여인원")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.pointColor)
            }
            .padding(.leading, 13)
            .padding(.top, 13)
            

            VStack(alignment: .leading) {
                // TODO: 모델 연동 시, 이곳에 위치 값을 넣기
                Text("서울시 종로구 (약 1.2km)")
                    .foregroundStyle(Color.staticGray1)
                    .padding(.bottom, 5)
                
                // TODO: 모델 연동 시, 이곳에 시간 값을 넣기
                Text("4월 11일 목요일 16:30 ~ 18:30")
                    .foregroundStyle(Color.staticGray1)
                    .padding(.bottom, 5)
                
                // TODO: 모델 연동 시, 이곳에 참여인원, 제한인원 값 넣기
                Text("4 / 8")
                    .foregroundStyle(Color.staticGray1)
            }
            .padding(.leading, 13)
            .padding(.top, 13)
            
            Spacer()
        }
        .padding(.bottom, 13)
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
