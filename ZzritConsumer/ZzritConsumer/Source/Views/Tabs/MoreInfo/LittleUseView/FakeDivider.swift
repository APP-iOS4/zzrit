//
//  FakeDivider.swift
//  ZzritConsumer
//
//  Created by Irene on 4/10/24.
//

import SwiftUI

// 회색 굵은 선
struct FakeDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 10)
            .foregroundStyle(Color.staticGray5)
    }
}

#Preview {
    FakeDivider()
}
