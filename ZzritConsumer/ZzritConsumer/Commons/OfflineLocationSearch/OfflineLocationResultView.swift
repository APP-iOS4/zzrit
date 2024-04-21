//
//  OfflineLocationResultView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import SwiftUI

struct OfflineLocationResultView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image(.zziritLogo)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
            
            Text("검색어를 입력해 주세요. ")
                .padding(10)
                .foregroundStyle(Color.staticGray)
            
            Spacer()
        }
    }
}

#Preview {
    OfflineLocationResultView()
}
