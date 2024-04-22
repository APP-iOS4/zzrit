//
//  SubTitleModifier.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/8/24.
//

import SwiftUI

struct SubTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .font(.title3)
            .fontWeight(.bold)
    }
}
