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
    @Binding  var isOnline: Bool
    // 현재 위치 이름값
    @State private var offlineLocationString: String = "서울특별시 종로구"
    
    //MARK: - body
    
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
                Label(isOnline ? "온라인" : offlineLocationString, systemImage: isOnline ? "wifi" : "location.circle")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.pointColor)
            }
            .padding(10)

        }
        .background(Color(red: 255.0 / 255.0, green: 236.0 / 255.0, blue: 238.0 / 255.0))
        .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
        // 오프라인 위치 검색 시트 토글
        .sheet(isPresented: $isSheetOn, content: {
            OfflineLocationSearchView(offlineLocationString: $offlineLocationString)
        })
    }
}

#Preview {
    MainLocationView(isOnline: .constant(false))
}
