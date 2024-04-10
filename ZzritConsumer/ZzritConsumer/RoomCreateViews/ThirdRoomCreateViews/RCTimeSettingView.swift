//
//  RCTimeSetting.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/10/24.
//

import SwiftUI

struct RCTimeSettingView: View {
    @State var isShowingTimeSettingSheet: Bool = false
    @State var selectedTime: String = "오전 10:00"
    
    var body: some View {
        Button {
            isShowingTimeSettingSheet.toggle()
        } label: {
            HStack {
                Label(selectedTime, systemImage: "alarm")
                Spacer()
            }
            .foregroundStyle(.black)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: Configs.cornerRadius)
                    .stroke(Color.staticGray6, lineWidth: 1.0)
            }
        }
        .sheet(isPresented: $isShowingTimeSettingSheet) {
            HStack {
                Text("시간 선택 화면")
            }
            .presentationDetents([.medium])
        }
    }
}

#Preview {
    RCTimeSettingView()
}
