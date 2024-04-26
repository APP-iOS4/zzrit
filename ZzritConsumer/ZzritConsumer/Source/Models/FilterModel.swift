//
//  FilterModel.swift
//  ZzritConsumer
//
//  Created by SunJoon Lee on 4/23/24.
//

import ZzritKit

struct FilterModel: Equatable {
    var title: String = ""
    var isOnline: Bool?
    var category: CategoryType?
    var dateType: DateType?
    
    var isFiltered: Bool {
        !(category == nil && dateType == nil && isOnline == nil)
    }
    
    mutating func resetValues() {
        category = nil
        dateType = nil
        isOnline = nil
    }
}
