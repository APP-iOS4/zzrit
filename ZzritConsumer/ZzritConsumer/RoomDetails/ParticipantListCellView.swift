//
//  ParticipantListView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ParticipantListCellView: View {
    let room: RoomModel
    
    let participant: UserModel
    
    private var isLeader: Bool {
        room.leaderID == participant.userID ? true : false
    }
    
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
                    if isLeader {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(.yellow)
                    }
                    // 사용자의 닉네임
                    Text("\(participant.userName)")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.staticGray1)
                }
                
                // 사용자의 정전기 지수
                Text("\(Int(participant.staticGauge))W")
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
    ParticipantListCellView(room: RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "https://picsum.photos/200", isOnline: false, status: .activation, leaderID: "", limitPeople: 8), participant: UserModel(userID: "", userName: "테스트 네임", userImage: "dummyImage", gender: .male, birthYear: 1900, staticGauge: 50.0, agreeServiceDate: Date(), agreePrivacyDate: Date(), agreeLocationDate: Date()))
}
