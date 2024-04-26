//
//  NetworkConnectionWarnningView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/26/24.
//

import SwiftUI

struct NetworkConnectionWarnningView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Spacer()
                
                Image("ZziritLogoImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                
                VStack(spacing: 5) {
                    Text("네트워크에 연결되지 않았습니다.")
                    Text("네트워크에 연결되면 자동으로 화면이 닫힙니다.")
                }
                
                Spacer()
                
                VStack(spacing: 10) {
                    ProgressView()
                    Text("네트워크 연결을 기다리고 있습니다.")
                }
            }
        }
    }
}

#Preview {
    NetworkConnectionWarnningView()
}
