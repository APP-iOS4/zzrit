//
//  File.swift
//  
//
//  Created by woong on 4/8/24.
//

import Foundation

public enum CategoryType: String, CaseIterable ,Codable {
    case hobby = "취미"
    case sport = "운동 • 야외활동"
    case study = "스터디"
    case art = "예술 • 공연"
    case game = "게임"
    case food = "맛집 탐방"
    case cafe = "카페 탐방"
    case leisure = "레저"
    case culture = "인문 • 교양"
    case beauty = "뷰티 • 패션"
    case camera = "사진 • 영상"
    case etc = "기타"
}
