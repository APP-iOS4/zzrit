//
//  HiddenRectangle.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/23/24.
//

import SwiftUI

struct HiddenRectangle: View {
    var body: some View {
        Rectangle()
            .frame(width: 1, height: 1)
            .foregroundStyle(.clear)
    }
}
