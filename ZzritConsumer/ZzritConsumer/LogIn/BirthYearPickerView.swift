//
//  BirthYearPickerView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

struct BirthYearPickerView: View {
    @Binding var selectedYear: Int
    
    var body: some View {
        Picker("Choose a color", selection: $selectedYear) {
            ForEach(1800...Calendar.current.component(.year, from: Date()), id: \.self) { year in
                Text(String(year))
            }
        }
        .pickerStyle(.wheel)
    }
    
}

#Preview {
    BirthYearPickerView(selectedYear: .constant(2000))
}
