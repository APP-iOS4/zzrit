//
//  ErrorTextView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/8/24.
//

import SwiftUI

struct ErrorTextView: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.subheadline)
            .foregroundStyle(Color.red)
    }
}

struct SpaceErrorTextView: View {
    var body: some View {
        Text(" ")
            .font(.subheadline)
    }
}

#Preview {
    ErrorTextView(title: "잘못된 정보입니다.")
}
