//
//  RoomProcedureSelectButtonView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI

struct ProcedureSelectButton: View {
    @Binding var selectedMethod: RoomProcedureMethod
    let procedureMethod: RoomProcedureMethod
    
    var isSelected: Bool {
        selectedMethod == procedureMethod ? true : false
    }
    
    var textColor: Color {
        isSelected ? .pointColor : .staticGray3
    }
    
    var body: some View {
        Button {
            selectedMethod = procedureMethod
        } label: {
            Text(procedureMethod.rawValue)
                .foregroundStyle(textColor)
                .fontWeight(.bold)
        }
        .disabled(isSelected)
    }
}

#Preview {
    ProcedureSelectButton(selectedMethod: .constant(.all), procedureMethod: .all)
}
