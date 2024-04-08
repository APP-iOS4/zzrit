//
//  RoomCardView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/8/24.
//

import SwiftUI

struct RoomCardView: View {
    var titleToHStackPadding: CGFloat
    
    // MARK: - init
    
    init(titleToHStackPadding: CGFloat) {
        self.titleToHStackPadding = titleToHStackPadding
    }
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            // 모임 위치
            Text("광화문역 (0.1km)")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            // 모임 제목
            Text("비지니스 영어회화 스터디")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)

            HStack {
                // 날짜 및 시간
                Text("4/5 16:30")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                // 참여 인원 및 제한 인원
                // TODO: 라벨 오퍼시티 값을 줄 것인지 안 줄 것인지
                Label("8 / 10", systemImage: "person.circle.fill")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Capsule())
            }
            // 패딩 변수값 적용하는 곳
            .padding(.top, titleToHStackPadding)
        }
        .padding(20)
        .background(
            // 배경 이미지
            ZStack {
                // 이미지 삽입 부분
                Image(.dummy)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                // 배경 이미지 오퍼시티 값
                // TODO: 배경 이미지에 오퍼시티 값을 줄 것인지 안 줄 것인지
                Color.black.opacity(0.6)
            }
        )
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    RoomCardView(titleToHStackPadding: 100)
}
