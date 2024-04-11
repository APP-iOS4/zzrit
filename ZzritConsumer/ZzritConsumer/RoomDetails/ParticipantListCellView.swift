//
//  ParticipantListView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

struct ParticipantListCellView: View {
    // 임시 닉네임 변수
    var nickName: String
    
    // MARK: - body
    
    var body: some View {
        HStack {
            // 사용자의 프로필
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(Color.staticGray4)
                .clipShape(Circle())
                .frame(maxWidth: 50)
                
            
            VStack(alignment: .leading) {
                HStack {
                    // 만약 이 사람이 방장일 시
                    if false {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(.yellow)
                    }
                    // 사용자의 닉네임
                    Text("\(nickName)")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.staticGray1)
                }
                
                // 사용자의 정전기 지수
                Text("75W")
                    .font(.caption2)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 5)
                    .foregroundStyle(.white)
                    .background(Color.pointColor)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
        }
    }
}

#Preview {
    ParticipantListCellView(nickName: "박현상")
}
