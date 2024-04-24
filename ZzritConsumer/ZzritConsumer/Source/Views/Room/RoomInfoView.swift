//
//  RoomInfoView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import CoreLocation
import SwiftUI

import ZzritKit

struct RoomInfoView: View {
    let room: RoomModel
    
    let participantsCount: Int
    // 그리드 뷰에 나타낼 열의 개수
    let columns: [GridItem] = [GridItem(.flexible(minimum: 85, maximum: 85)), GridItem(.flexible())]
    
    @Binding var offlineLocation: OfflineLocationModel?
    
    private var isGenderLimit: Bool {
        if room.genderLimitation != nil { return true }
        else { return false }
    }
    
    private var isScoreLimit: Bool {
        if room.scoreLimitation != nil { return true }
        else { return false }
    }
    
    @State private var simpleAddress: String = ""
    @State private var distance: Double = 0.0
    
    private var distanceString: String {
        let formattedString = String(format: "%.1f", distance)
        return "약 \(formattedString)km"
    }

    // MARK: - body
    
    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading) {
            Text("위치")
                .fontWeight(.bold)
                .foregroundStyle(Color.pointColor)
                .padding(.bottom, 5)
                .padding(.top, 13)
            
            Text("\(simpleAddress) (\(distanceString))")
                .foregroundStyle(Color.staticGray1)
                .padding(.bottom, 5)
                .padding(.top, 13)
            
            Text("시간")
                .fontWeight(.bold)
                .foregroundStyle(Color.pointColor)
                .padding(.bottom, 5)
            
            HStack {
                Text((DateService.shared.formattedString(date: room.dateTime, format: "M월 dd일 E요일 HH:mm")))
            }
            .foregroundStyle(Color.staticGray1)
            .padding(.bottom, 5)
            
            Text("참여인원")
                .fontWeight(.bold)
                .foregroundStyle(Color.pointColor)
                .padding(.bottom, 5)
            
            Text("\(participantsCount) / \(room.limitPeople)")
                .foregroundStyle(Color.staticGray1)
                .padding(.bottom, 5)
            
            // 성벌 제한이 설정되어 있는가?
            if isGenderLimit {
                Text("성별 제한")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.pointColor)
                    .padding(.bottom, 5)
                
                Text(room.genderLimitation!.rawValue)
                    .foregroundStyle(Color.staticGray1)
                    .padding(.bottom, 5)
            }
            
            // 정전기 제한이 설정되어 있는가?
            if isScoreLimit {
                Text("정전기 제한")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.pointColor)
                
                Text("\(room.scoreLimitation!)W")
                    .foregroundStyle(Color.staticGray1)
            }
        }
        .padding(.leading, 13)
        .padding(.bottom, 13)
        .frame(maxWidth: .infinity)
        .overlay {
            RoundedRectangle(cornerRadius: Configs.cornerRadius)
                .strokeBorder(Color.staticGray4, lineWidth: 1.0)
        }
        .task {
            simpleAddress = await room.simpleAddress() ?? "(unknown)"
            if let offlineLocation {
                let fromCoordinate = CLLocationCoordinate2D(latitude: offlineLocation.latitude, longitude: offlineLocation.longitude)
                distance = room.distance(from: fromCoordinate) ?? 0.0
            }
        }
    }
}

#Preview {
    RoomInfoView(room: RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "", isOnline: false, status: .activation, leaderID: "", limitPeople: 8), participantsCount: 0, offlineLocation: .constant(nil))
}
