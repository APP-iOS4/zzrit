//
//  RoomCategoryView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/8/24.
//

import SwiftUI

struct RoomCategoryView: View {
    var title: String
    
    // MARK: - init
    
    init(_ title: String) {
        self.title = title
    }
    
    // MARK: - body
    
    var body: some View {
        Text(title)
            .padding(.horizontal, 7)
            .padding(.vertical, 5)
            .overlay {
                Capsule()
                    .stroke(lineWidth: 1.0)
            }
            .font(.caption)
            .foregroundStyle(Color.pointColor)
            .background(Color.lightPointColor)
            .clipShape(Capsule())
    }
}

#Preview {
    RoomCategoryView("취미")
}
