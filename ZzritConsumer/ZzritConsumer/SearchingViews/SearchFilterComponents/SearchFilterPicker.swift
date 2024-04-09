//
//  FilterPickerView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

struct SearchFilterPicker<Data>: View where Data: Hashable {
    
    let type: String
    let datas: [Data]
    @Binding var selection: Data
    
    var body: some View {
        HStack {
            Text(type)
                .fontWeight(.bold)
            
            Spacer()
            
            Picker(type, selection: $selection) {
                ForEach(datas, id: \.self) { data in
                    Text("\(data)")
                }
                .pickerStyle(.menu)
                .tint(.pointColor)
                .padding([.horizontal], -20.0)
            }
        }
    }
}

#Preview {
    SearchFilterPicker<CategoryPickerEnum>(
        type: "카테고리",
        datas: CategoryPickerEnum.allCases,
        selection: .constant(CategoryPickerEnum.all)
    )
}
