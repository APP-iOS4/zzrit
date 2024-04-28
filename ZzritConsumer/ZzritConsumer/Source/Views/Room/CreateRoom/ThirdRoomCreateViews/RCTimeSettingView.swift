//
//  RCTimeSetting.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/10/24.
//

import SwiftUI

struct RCTimeSettingView: View {
    @Binding var isShowingTimeSheet: Bool
    @Binding var timeSelection: Date?
    
    var timeSelectionBinding: Binding<Date> {
        Binding(
            get: { timeSelection ?? Date() },
            set: { timeSelection = $0 }
        )
    }
    
    var body: some View {
        DatePicker("시간을 정해주세요.",
            selection: timeSelectionBinding,
            displayedComponents: .hourAndMinute
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .tint(Color.pointColor)
        .onAppear {
            UIDatePicker.appearance().minuteInterval = 10
        }
        
        GeneralButton("완료") {
            isShowingTimeSheet.toggle()
        }
        .padding(Configs.paddingValue)
    }
}

#Preview {
    RCTimeSettingView(isShowingTimeSheet: .constant(true), timeSelection: .constant(Date()))
}
