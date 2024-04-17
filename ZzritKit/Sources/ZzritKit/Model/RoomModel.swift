//
//  SwiftUIView.swift
//  
//
//  Created by woong on 4/8/24.
//

import Foundation

import FirebaseFirestore

/// 모임 모델
public struct RoomModel: Identifiable, Codable {
    /// 모임 ID
    @DocumentID public var id: String? = UUID().uuidString
    /// 모임 제목
    public var title: String
    /// 모임 카테고리
    public var category: CategoryType
    /// 모임 일시(하나로 일자와 모임 시간 같이 사용)
    public var dateTime: Date
    /// 모임 위도
    public var placeLatitude: Double?
    /// 모임 경도
    public var placeLongitude: Double?
    /// 모임 장소(가게 등) 이름
    public var placeName: String?
    /// 모임 상세 설명
    public var content: String
    /// 모임 이미지
    public var coverImage: String
    /// 모임의 온라인 여부 체크용
    public var isOnline: Bool
    /// 모임이 온라인일 경우 사용하는 플랫폼
    public var platform: PlatformType?
    /// 모임의 종료 여부
    public var status: ActiveType
    /// 모임장 id
    public var leaderID: String
    /// 모임 최대 인원
    public var limitPeople: Int
    /// 성별 제한
    public var genderLimitation: GenderType?
    /// 점수 제한
    public var scoreLimitation: Int?
    
    public var lastChatContent: String?
    
    public var lastChatTime: Date?
    
    public init(id: String? = UUID().uuidString, title: String, category: CategoryType, dateTime: Date, placeLatitude: Double? = nil, placeLongitude: Double? = nil, placeName: String? = nil ,content: String, coverImage: String, isOnline: Bool, platform: PlatformType? = nil, status: ActiveType, leaderID: String, limitPeople: Int) {
        self.id = id
        self.title = title
        self.category = category
        self.dateTime = dateTime
        self.placeLatitude = placeLatitude
        self.placeLongitude = placeLongitude
        self.placeName = placeName
        self.content = content
        self.coverImage = coverImage
        self.isOnline = isOnline
        self.platform = platform
        self.status = status
        self.leaderID = leaderID
        self.limitPeople = limitPeople
    }
    
    /// 모임 종료 시간
    public func limitTime(time: Int = 24) -> Date {
        // 모임의 일시는 반드시 존재하기때문에 24시간을 더한 값도 반드시 존재함.
        // 따라서 force Unwrapping 적용함.
        return Calendar.current.date(byAdding: .hour, value: time, to: self.dateTime)!
    }
    
    public var roomImage: URL {
        guard let url = URL(string: coverImage) else { return URL(string: "https://picsum.photos/200")! }
        return url
    }
}
