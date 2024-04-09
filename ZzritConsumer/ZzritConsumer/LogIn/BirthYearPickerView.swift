//
//  BirthYearPickerView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

struct BirthYearPickerView: View {
    @Binding var selectedYear: Int
    @Environment (\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Picker("출생년도를 선택해주세요.", selection: $selectedYear) {
                ForEach(1800...Calendar.current.component(.year, from: Date()), id: \.self) { year in
                    Text(String(year))
                }
            }
            .pickerStyle(.wheel)
            Button(action: {
                dismiss()
            }, label: {
                Text("선택 완료")
                    .foregroundStyle(Color.pointColor)
            })
        }
        .presentationDetents([.height(250)])
        .interactiveDismissDisabled()
    }
    
}

#Preview {
    BirthYearPickerView(selectedYear: .constant(2000))
}
