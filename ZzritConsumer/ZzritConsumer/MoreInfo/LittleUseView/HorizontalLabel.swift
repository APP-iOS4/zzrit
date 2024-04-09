//
//  HorizontalLabel.swift
//  ZzritConsumer
//
//  Created by Irene on 4/10/24.
//

import SwiftUI

// List의 Cell 라벨
struct HorizontalLabel: View {
    var string: String
    var body: some View {
            HStack {
                Text(string)
                Spacer()
            }
    }
}

#Preview {
    HorizontalLabel(string: "공지사항")
}
