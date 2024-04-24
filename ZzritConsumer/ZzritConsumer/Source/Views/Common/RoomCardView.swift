//
//  RoomCardView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/8/24.
//

import CoreLocation
import SwiftUI

import ZzritKit

struct RoomCardView: View {
    let room: RoomModel
    let roomService = RoomService.shared
    
    @Binding var offlineLocation: OfflineLocationModel?
    
    @State private var simpleAddress: String = "(unknown)"
    @State private var distance: Double = 0.0
    @State private var participantsCount: Int = 0
    @State private var roomImage: UIImage?
    
    var titleToHStackPadding: CGFloat
    
    private var distanceString: String {
        let formattedString = String(format: "%.1f", distance)
        return "약 \(formattedString)km"
    }
    
    private var locationString: String {
        if let platformName = room.platform?.rawValue {
            return platformName
        } else {
            return "\(simpleAddress) (\(distanceString))"
        }
    }
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            // 모임 위치
            Text("\(locationString)")
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            // 모임 제목
            Text(room.title)
                .lineLimit(1)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            
            HStack {
                // 날짜 및 시간
                Text(DateService.shared.formattedString(date: room.dateTime, format: "M/dd HH:mm"))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Spacer()
                
                // 참여 인원 및 제한 인원
                // TODO: 라벨 오퍼시티 값을 줄 것인지 안 줄 것인지
                Label("\(participantsCount) / \(room.limitPeople)", systemImage: "person.circle.fill")
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
                if roomImage != nil {
                    Image(uiImage: roomImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxHeight: 400)
                        .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
                } else {
                    Image("ZziritLogoImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxHeight: 400)
                        .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
                }
                // 배경 이미지 오퍼시티 값
                // TODO: 배경 이미지에 오퍼시티 값을 줄 것인지 안 줄 것인지
                Color.black.opacity(0.6)
            }
        )
        .clipShape(.rect(cornerRadius: 10))
        .frame(minWidth: 350,maxWidth: 350)
        .onAppear {
            Task {
                do {
                    if let roomId = room.id {
                        participantsCount = try await roomService.joinedUsers(roomID: roomId).count
                        roomImage = await ImageCacheManager.shared.findImageFromCache(imagePath: room.coverImage)
                    }
                } catch {
                    Configs.printDebugMessage("\(error)")
                }
                
                simpleAddress = await room.simpleAddress() ?? "(unknown)"
                if let offlineLocation {
                    let fromCoordinate = CLLocationCoordinate2D(latitude: offlineLocation.latitude, longitude: offlineLocation.longitude)
                    distance = room.distance(from: fromCoordinate) ?? 0.0
                }
            }
        }
    }
}
//
//#Preview {
//    RoomCardView(room: RoomModel(title: "같이 모여서 가볍게 치맥하실 분...", category: .hobby, dateTime: Date(), content: "", coverImage: "https://picsum.photos/200", isOnline: false, status: .activation, leaderID: "", limitPeople: 8), titleToHStackPadding: 100, offlineLocation: .constant(nil))
//}
