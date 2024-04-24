//
//  LoadingView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/24/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.clear
                .background(.regularMaterial)
            
            ProgressView()
        }
    }
}

#Preview {
    LoadingView()
}
