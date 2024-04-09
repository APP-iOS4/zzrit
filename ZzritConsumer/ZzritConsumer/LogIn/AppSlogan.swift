//
//  AppSlogan.swift
//  ZzritConsumer
//
//  Created by Irene on 4/8/24.
//

import SwiftUI
import ZzritKit

struct AppSlogan: View {
    var body: some View {
        Text("만나는 순간의 짜릿함")
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(Color.staticGray1)
        Text("ZZ!RIT")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .foregroundStyle(Color.pointColor)
    }
}

#Preview {
    AppSlogan()
}
