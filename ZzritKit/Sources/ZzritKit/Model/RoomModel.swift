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
    @DocumentID public var id: String?
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
    /// 모임 상세 설명
    public var content: String
    /// 모임 이미지
    public var coverImage: URL
    /// 모임의 온라인 여부 체크용
    public var isOnline: Bool
    /// 모임이 온라인일 경우 사용하는 플랫폼
    public var platform: PlatformType?
    /// 모임의 종료 여부(가능하다면 연산프로퍼티로 수정)
    public var status: ActiveType
    /// 모임장 id
    public var leaderID: String
    /// 모임 최대 인원
    public var limitPeople: Int
    /// 성별 제한
    public var genderLimitation: GenderType?
    /// 점수 제한
    public var scoreLimitation: Int?
    
    
    /// 모임 종료 시간
    public func limitTime(time: Int = 24) -> Date {
        // 모임의 일시는 반드시 존재하기때문에 24시간을 더한 값도 반드시 존재함.
        // 따라서 force Unwrapping 적용함.
        return Calendar.current.date(byAdding: .hour, value: time, to: self.dateTime)!
    }
}
