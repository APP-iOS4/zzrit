//
//  RCTimeSetting.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/10/24.
//

import SwiftUI

struct RCTimeSettingView: View {
    @Binding var isShowingTimeSheet: Bool
    @Binding var timeSelection: Date
    
    var body: some View {
        DatePicker("시간을 정해주세요.",
            selection: $timeSelection,
            displayedComponents: .hourAndMinute
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .tint(Color.pointColor)
        
        GeneralButton("완료") {
            isShowingTimeSheet.toggle()
        }
        .padding(Configs.paddingValue)
    }
}

#Preview {
    RCTimeSettingView(isShowingTimeSheet: .constant(true), timeSelection: .constant(Date()))
}