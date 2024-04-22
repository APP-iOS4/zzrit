//
//  DateType.swift
//  StaticTemp
//
//  Created by 이선준 on 4/15/24.
//

import Foundation

enum DateType: String, Equatable {
    case today = "오늘"
    case tomorrow = "내일"
    case dayAfterTomorrow = "내일 모레"
    
    var description: String {
        switch self {
        case .today:
            // 오늘
            let today = self.date
            let date = Calendar.current.component(.day, from: today)
            let weekday = weekdayToString(weekday: Calendar.current.component(.weekday, from: today))
            return "\(date)일 (\(weekday))"
        case .tomorrow:
            // 내일
            let tomorrow = self.date
            let date = Calendar.current.component(.day, from: tomorrow)
            let weekday = weekdayToString(weekday: Calendar.current.component(.weekday, from: tomorrow))
            return "\(date)일 (\(weekday))"
        case .dayAfterTomorrow:
            // 모레
            let dayAfterTomorrow = self.date
            let date = Calendar.current.component(.day, from: dayAfterTomorrow)
            let weekday = weekdayToString(weekday: Calendar.current.component(.weekday, from: dayAfterTomorrow))
            return "\(date)일 (\(weekday))"
        }
    }
    
    var date: Date {
        switch self {
        case .today:
            Date()
        case .tomorrow:
            Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        case .dayAfterTomorrow:
            Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()
        }
    }
    
    func weekdayToString(weekday: Int) -> String {
        switch weekday {
        case 1:
            return "일"
        case 2:
            return "월"
        case 3:
            return "화"
        case 4:
            return "수"
        case 5:
            return "목"
        case 6:
            return "금"
        case 7:
            return "토"
        default:
            return ""
        }
    }
}
