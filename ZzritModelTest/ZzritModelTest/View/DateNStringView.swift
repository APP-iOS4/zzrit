//
//  DateNStringView.swift
//  ZzritModelTest
//
//  Created by woong on 4/12/24.
//

import SwiftUI

import ZzritKit

struct DateNStringView: View {
    @State private var date: Date = Date()
    @State private var stringDate: String = ""
    
    var body: some View {
        VStack {
            DatePicker("날짜", selection: $date)
            
            Text(date.toString())
            Text(date.toStringYear())
            Text(date.toStringMonth())
            Text(date.toStringDate())
            Text(date.toStringHour())
            Text(date.toStringMinute())
            Text(date.toStringSecond())
            
            TextField("yyyy-mm-dd hh:mm:ss", text: $stringDate)
            if let dateToString = stringDate.toDate() {
                // 기준시가 UTC 기준이라 9시간 더해져서 나옴.
                Text("\(dateToString)")
            }
            
            
        }
    }
}

#Preview {
    DateNStringView()
}
