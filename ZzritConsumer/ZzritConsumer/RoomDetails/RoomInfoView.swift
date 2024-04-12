//
//  RoomInfoView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

struct RoomInfoView: View {
    // FIXME: 모델에 성별 제한은 nil값으로 설정되어있음 -> 모델 받은 걸 토대로 연산프로퍼티로 변경
    // 성별 제한이 있는가?
    var isGenderLimit: Bool
    // FIXME: 모델에 정전기 제한도는 nil값으로 설정되어있음 -> 모델 받은 걸 토대로 연산프로퍼티로 변경
    // 정전기 제한이 있는가?
    var isScoreLimit: Bool
    // 그리드 뷰에 나타낼 열의 개수
    let columns: [GridItem] = [GridItem(.flexible(minimum: 85, maximum: 85)), GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading) {
            Text("위치")
                .fontWeight(.bold)
                .foregroundStyle(Color.pointColor)
                .padding(.bottom, 5)
                .padding(.top, 13)
            
            // TODO: 모델 연동 시, 이곳에 위치 값을 넣기
            Text("서울시 종로구 (약 1.2km)")
                .foregroundStyle(Color.staticGray1)
                .padding(.bottom, 5)
                .padding(.top, 13)
            
            Text("시간")
                .fontWeight(.bold)
                .foregroundStyle(Color.pointColor)
                .padding(.bottom, 5)
            
            // TODO: 모델 연동 시, 이곳에 시간 값을 넣기
            Text("12월 11일 목요일 16:30 ~ 18:30")
                .foregroundStyle(Color.staticGray1)
                .padding(.bottom, 5)
            
            Text("참여인원")
                .fontWeight(.bold)
                .foregroundStyle(Color.pointColor)
                .padding(.bottom, 5)
            
            // TODO: 모델 연동 시, 이곳에 참여인원, 제한인원 값 넣기
            Text("4 / 8")
                .foregroundStyle(Color.staticGray1)
                .padding(.bottom, 5)
            
            // 성벌 제한이 설정되어 있는가?
            if isGenderLimit {
                Text("성별 제한")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.pointColor)
                    .padding(.bottom, 5)
                
                // TODO: 모델 연동 시, 이곳에 정전기 제한 값 넣기
                Text("남자만")
                    .foregroundStyle(Color.staticGray1)
                    .padding(.bottom, 5)
            }
            
            // 정전기 제한이 설정되어 있는가?
            if isScoreLimit {
                Text("정전기 제한")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.pointColor)
                
                // TODO: 모델 연동 시, 이곳에 정전기 제한 값 넣기
                Text("50W")
                    .foregroundStyle(Color.staticGray1)
            }
        }
        .padding(.leading, 13)
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
    RoomInfoView(isGenderLimit: true, isScoreLimit: true)
}
