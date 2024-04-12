//
//  OfflineLocationSearchView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import SwiftUI

struct OfflineLocationSearchView: View {
    @Binding var offlineLocationString: String
    
    @FocusState private var isTextFocus: Bool
    
    var body: some View {
        OfflineLocationSearchTextFieldView(offlineLocationString: $offlineLocationString)
            .focused($isTextFocus)
        
        // 텍스트 입력 중에는 사라짐
        if !isTextFocus {
            OfflineLocationResultView()
        }
        
        Spacer()
    }
}

#Preview {
    OfflineLocationSearchView(offlineLocationString: .constant("서울특별시 종로구"))
}
