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
}
