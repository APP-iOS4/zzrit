//
//  ParticipantListView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

struct ParticipantListCellView: View {
    var nickName: String
    
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
                // 사용자의 닉네임
                Text("\(nickName)")
                    .fontWeight(.bold)
                
                // 사용자의 정전기 지수
                Text("75W")
                    .font(.caption2)
                    .padding(2)
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
