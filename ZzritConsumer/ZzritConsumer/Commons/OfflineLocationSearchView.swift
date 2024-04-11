//
//  OfflineLocationSearchView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import SwiftUI

struct OfflineLocationSearchView: View {
    @Binding var offlineLocationString: String
    
    var body: some View {
        OfflineLocationSearchTextFieldView(offlineLocationString: $offlineLocationString)
        
        OfflineLocationResultView()
    }
}

#Preview {
    OfflineLocationSearchView(offlineLocationString: .constant("서울특별시 종로구"))
}
