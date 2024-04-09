//
//  DateService.swift
//
//
//  Created by Sanghyeon Park on 4/9/24.
//

import Foundation

@available(iOS 15.0, *)
public final class DateService {
    /// DateFormatter 등 자원 낭비를 방지하기 위해 싱글턴으로 관리
    public static let shared = DateService()
    
    let dateFormatter = DateFormatter()
    
    private init() {
        /// 인스턴스 생성시 dateFormatter 로케일 설정
        dateFormatter.locale = Locale(identifier: "ko_KR")
    }
    
    /**
    24시간제 -> 12시간제 변환
     # Description
     - 24시간제 시간을 오전/오후 시간대로 변환합니다.
     
     # Parameters:
     - time : 시간정보 (ex. 16:00)
     
     # Return:
     - String
        - 올바른 시간의 경우 변환된 시간을 반환합니다.
            - 16:00 -> **오후 4:00**
        - 올바르지 않은 시간의 경우 입력값을 그대로 반환합니다.
     */
    public func timeString(time: String) -> String {
        dateFormatter.dateFormat = "HH:mm"
        
        guard let date = dateFormatter.date(from: time) else {
            return time
        }
        
        dateFormatter.dateFormat = "a h:mm"
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        
        return dateFormatter.string(from: date)
    }
    
    /**
    날짜 변환
     # Description
     - Datetime을 현재 날짜(yyyy-MM-dd)형식 또는 (MM-dd)으로 변환합니다.
     
     # Parameters:
     - date : Date
     
     # Return:
     - String
        - __현재와 입력받은 날짜의 연도가 같은 경우__ : MM-dd 반환
        - __현재와 입력받은 날짜의 연도가 다른 경우__ : yyyy-MM-dd 반환
     */
    public func dateString(date: Date, isContainYear: Bool = false) -> String {
        let yearFormat = Date.FormatStyle()
            .year()
        
        let currentYear = Date().formatted(yearFormat)
        let inputYear = date.formatted(yearFormat)
        
        if currentYear != inputYear || isContainYear {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        } else {
            dateFormatter.dateFormat = "MM-dd"
        }
        return dateFormatter.string(from: date)
    }
    
    /// 날짜변환
    /// 설정한 양식으로 날짜를 반환합니다.
    /// - Parameter date: 변환할 Date 타입 날짜
    /// - Parameter format: 표시할 String 타입의 포맷(기본값: yyyy-M-d HH:mm)
    /// - Returns: 변환 된 String 타입의 날짜
    public func formattedString(date: Date = Date(), format: String = "yyyy-M-d HH:mm") -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    /// 날짜변환
    /// 설정한 양식으로 날짜를 반환합니다.
    /// - Parameter string: 변환할 String 타입 날짜
    /// - Parameter from: 변환전 String 타입의 포맷
    /// - Parameter to: 변환할 String 타입의 포맷
    /// - Returns: 변환 된 String 타입의 날짜
    public func formattedString(string: String, from beforeFormat: String, to afterFormat: String) -> String {
        dateFormatter.dateFormat = beforeFormat
        if let date = dateFormatter.date(from: string) {
            dateFormatter.dateFormat = afterFormat
            return dateFormatter.string(from: date)
        } else {
            return "(알수없는 날짜)"
        }
    }
    
    /// 입력받은 (String) 타입의 시간을 현재시간으로부터 상대시간으로 반환합니다.
    /// - Parameter for: 변환하고자 하는 (String) 타입의 시간
    /// - Parameter format: for 파라미터의 DateFormat
    /// - Returns: (String) 잘못된 시간일 경우 공백 반환
    public func relativeString(for date: String, format: String = "yyyy-MM-dd HH:mm:ss.SSS") -> String {
        dateFormatter.dateFormat = format
        guard let tempDate = dateFormatter.date(from: date) else { return "" }
        
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateTimeStyle = .named
        formatter.unitsStyle = .short
        let dateToString = formatter.localizedString(for: tempDate, relativeTo: .now)
        return dateToString.hasSuffix("초 전") ? "방금" : dateToString
    }

}
