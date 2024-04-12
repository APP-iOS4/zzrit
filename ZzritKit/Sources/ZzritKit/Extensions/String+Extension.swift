//
//  File.swift
//  
//
//  Created by woong on 4/12/24.
//

import Foundation

extension String {
    /**
     - 문자열을 String으로 바꿔주는 메서드
     - 문자열 끝에 .toDate()로 쓰면 Date? 를 반환.
     - 옵셔널이 반환되기 때문에 옵셔널 언래핑을 하고 사용해야 함.
     - 문자열의 형식은 "2024-03-01 08:35:40" 형태여야함.
     */
    public func toDate() -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-DD HH:mm:ss"
        df.timeZone = TimeZone(identifier: "UTC")
        if let date = df.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
