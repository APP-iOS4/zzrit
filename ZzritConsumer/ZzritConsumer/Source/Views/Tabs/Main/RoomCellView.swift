//
//  RoomCellView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/8/24.
//

import SwiftUI

import ZzritKit

struct RoomCellView: View {
    let room: RoomModel
    
    let roomService = RoomService.shared
    
    @State private var participantsCount: Int = 0
    @State private var simpleAddress: String = ""
    
    // MARK: - body
    
    var body: some View {
        VStack {
            HStack {
                // 모임 타이틀
                Text(room.title)
                    .lineLimit(1)
                    .foregroundStyle(.black)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                // 카테고리
                RoomCategoryView(room.category.rawValue)
                    .font(.caption)
            }
            .padding(.bottom, 20)
            
            HStack {
                // 위치
                Label {
                    Text(simpleAddress)
                        .foregroundStyle(Color.staticGray1)
                } icon: {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundStyle(Color.pointColor)
                }
                .font(.caption)
                
                // 시간
                Label {
                    Text(DateService.shared.formattedString(date: room.dateTime, format: "HH:mm"))
                        .foregroundStyle(Color.staticGray1)
                } icon: {
                    Image(systemName: "clock.fill")
                        .foregroundStyle(Color.pointColor)
                }
                .font(.caption)
                
                Spacer()
                
                // 현재 인원 및 인원 제한 수
                Label {
                    Text("\(participantsCount) / \(room.limitPeople)")
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
        .onAppear {
            Task {
                do {
                    if let roomId = room.id {
                        participantsCount = try await roomService.joinedUsers(roomID: roomId).count
                    }
                } catch {
                    Configs.printDebugMessage("error: \(error)")
                }
                
                if let platformName = room.platform?.rawValue {
                    simpleAddress = platformName
                } else {
                    simpleAddress = await room.simpleAddress() ?? "(unknown)"
                }
            }
        }
    }
}

#Preview {
    RoomCellView(room: RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "", isOnline: false, status: .activation, leaderID: "", limitPeople: 8, scoreLimitaion: 40, genderLimitation: .female))
}
