//
//  SearchViewVM.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import Foundation

final class SearchViewVM {
    // 최근 검색어를 저장할 배열
    var recentHistory: [String] = []
    // 필터
    var filters: SearchFilter = SearchFilter()
}

struct SearchFilter {
    // 모임 방식
    var procedureMethod: RoomProcedureMethod = .all
    // 모임 날짜
    var date: DatePickerEnum = .today
    // 모임 위치
    var location: String = "전체"
    // 모임 카테고리
    var category: CategoryPickerEnum = .all
    
    // 모임 방식에 대한 임시 enum
    enum RoomProcedureMethod: String {
        case all = "전체"
        case online = "온라인"
        case offline = "오프라인"
    }
    
    // 날짜 피커를 위한 임시 Enum
    enum DatePickerEnum: String, CaseIterable {
        case today = "오늘 (4월 5일)"
        case tomorrow = "내일 (4월 6일)"
        case dayAfterTomorrow = "모레 (4월 7일)"
    }
    
    // 카테고리 피커를 위한 임시 Enum
    enum CategoryPickerEnum: String, CaseIterable {
        case all = "전체"
        case trip = "여행"
        case category1
        case category2
        case category3
        case category4
        case category5
        case category6
    }
}
