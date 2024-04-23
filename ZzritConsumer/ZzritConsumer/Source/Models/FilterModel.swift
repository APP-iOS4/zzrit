//
//  FilterModel.swift
//  ZzritConsumer
//
//  Created by SunJoon Lee on 4/23/24.
//

import ZzritKit

struct FilterModel: Equatable {
    var categorySelection: CategoryType?
    var dateSelection: DateType?
    var isOnline: Bool?
    var searchText: String = ""
    var locationString: String = ""
    
    var isFiltered: Bool {
        !(categorySelection == nil && dateSelection == nil && isOnline == nil)
    }
    
    mutating func resetValues() {
        categorySelection = nil
        dateSelection = nil
        isOnline = nil
        locationString = ""
    }
}
