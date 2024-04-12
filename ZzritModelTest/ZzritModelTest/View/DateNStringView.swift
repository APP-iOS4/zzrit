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
            //            .onChange(of: date) { _ in
            //                print(date)
            //            }
            Text(date.toString())
            
            TextField("yyyy-mm-dd hh:mm:ss", text: $stringDate)
            Text("\(stringDate.toDate())")
            
        }
    }
}

#Preview {
    DateNStringView()
}
