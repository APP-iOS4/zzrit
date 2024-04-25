//
//  LoadingView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/24/24.
//

import SwiftUI

struct LoadingView: View {
    let message: String?
    var body: some View {
        ZStack {
            Color.clear
                .background(.regularMaterial)
            
            VStack(spacing: 10) {
                ProgressView()
                
                if let message {
                    Text(message)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

#Preview {
    LoadingView(message: nil)
}
