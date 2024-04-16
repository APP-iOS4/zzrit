//
//  RCTimeSetting.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/10/24.
//

import SwiftUI

struct RCTimeSettingView: View {
    @State private var date: Date = Date()
    
    var body: some View {
        DatePicker("시간을 정해주세요.",
            selection: $date,
            displayedComponents: .hourAndMinute
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .tint(Color.pointColor)
    }
}

#Preview {
    RCTimeSettingView()
}
