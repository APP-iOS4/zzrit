//
//  RoomCellView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/8/24.
//

import SwiftUI

struct RoomCellView: View {
    
    // MARK: - body
    
    var body: some View {
        VStack {
            HStack {
                // 모임 타이틀
                Text("같이 모여서 가볍게 치맥하실 분...")
                    .lineLimit(1)
                    .foregroundStyle(.black)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                // 카테고리
                RoomCategoryView("술벙")
                    .font(.caption)
            }
            .padding(.bottom, 20)
            
            HStack {
                // 위치
                Label {
                    Text("일산구")
                        .foregroundStyle(Color.staticGray1)
                } icon: {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundStyle(Color.pointColor)
                }
                .font(.caption)
                
                // 시간
                Label {
                    Text("16:30")
                        .foregroundStyle(Color.staticGray1)
                } icon: {
                    Image(systemName: "clock.fill")
                        .foregroundStyle(Color.pointColor)
                }
                .font(.caption)
                
                Spacer()
                
                // 현재 인원 및 인원 제한 수
                Label {
                    Text("4 / 8")
                        .foregroundStyle(Color.staticGray1)
                } icon: {
                    Image(systemName: "person.fill")
                        .foregroundStyle(Color.pointColor)
                }
                .font(.caption)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.1), radius: 3)
            }
        )
    }
}

#Preview {
    RoomCellView()
}
