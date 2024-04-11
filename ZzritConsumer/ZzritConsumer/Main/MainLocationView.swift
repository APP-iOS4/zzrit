//
//  MainLocationView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import SwiftUI

struct MainLocationView: View {
    // 오프라인 시 시트를 띄울 불리언 변수
    @State private var isSheetOn: Bool = false
    // 온라인 선택한 건지 불리언 변수
    @State private var isOnline: Bool = false
    
    var body: some View {
        HStack {
            Menu {
                Button("온라인") {
                    isOnline = true
                }
                Button("위치설정") {
                    isOnline = false
                    isSheetOn.toggle()
                }
            } label: {
                Label(isOnline ? "온라인" : "오프라인", systemImage: isOnline ? "wifi" : "location.circle")
                    .foregroundStyle(Color.pointColor)
            }
            .padding(10)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 255.0 / 255.0, green: 236.0 / 255.0, blue: 238.0 / 255.0))
        .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
        .sheet(isPresented: $isSheetOn, content: {
            Text("시트 뷰")
        })
    }
}

#Preview {
    MainLocationView()
}
