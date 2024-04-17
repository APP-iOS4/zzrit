//
//  Date+Extension.swift
//
//
//  Created by Sanghyeon Park on 4/9/24.
//

import Foundation

extension Date {
    func addDay(at: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: at, to: self)!
    }
    /**
     - Date를 String으로 바꿔주는 메서드
     - 문자열 끝에 .toString()로 쓰면 String을 반환.
     - 문자열의 형식은 "2024-03-01 08:35:40" 형태로 반환됨.
     - 기준시는 UTC라 각 나라별로 시간 계산시 추가적인 계산 필요할 수 있음.
     */
    public func toString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        df.timeZone = TimeZone(identifier: "UTC")
        return df.string(from: self)
    }
    
    public func toStringYear() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy"
        df.timeZone = TimeZone(identifier: "UTC")
        return df.string(from: self)
    }
    
    public func toStringMonth() -> String {
        let df = DateFormatter()
        df.dateFormat = "MM"
        df.timeZone = TimeZone(identifier: "UTC")
        return df.string(from: self)
    }
    
    public func toStringDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "dd"
        df.timeZone = TimeZone(identifier: "UTC")
        return df.string(from: self)
    }
    
    public func toStringHour() -> String {
        let df = DateFormatter()
        df.dateFormat = "HH"
        df.timeZone = TimeZone(identifier: "UTC")
        return df.string(from: self)
    }
    
    public func toStringMinute() -> String {
        let df = DateFormatter()
        df.dateFormat = "mm"
        df.timeZone = TimeZone(identifier: "UTC")
        return df.string(from: self)
    }
    
    public func toStringSecond() -> String {
        let df = DateFormatter()
        df.dateFormat = "ss"
        df.timeZone = TimeZone(identifier: "UTC")
        return df.string(from: self)
    }
    
    public func toStringTimeLine() -> String {
        let df = DateFormatter()
        df.dateFormat = "a hh:mm"
        df.timeZone = TimeZone(identifier: "UTC")
        return df.string(from: self)
    }
}
