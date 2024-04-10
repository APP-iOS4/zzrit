//
//  StaticGuageProgressView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

struct StaticGuageProgressView: View {
    var staticGuage: Double
    var body: some View {
        GeometryReader { geometry in
            let viewWidth = geometry.size.width / 100
            // 정전기 지수 풍선
            VStack {
                ZStack(alignment: .top) {
                    if staticGuage > 94 {
                        Image(systemName: "bubble.right.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(Color.pointColor)
                    } else if staticGuage < 4 {
                        Image(systemName: "bubble.left.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(Color.pointColor)
                    } else {
                        Image(systemName: "bubble.middle.bottom.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(Color.pointColor)
                    }
                        Text("\(String(format: "%.1f", staticGuage))W")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(7)
                            .background(Color.pointColor)
                            .clipShape(.rect(cornerRadius: Configs.cornerRadius))
                }
                .position(CGPoint(x: viewWidth * limitMaxMin(staticGuage), y: 22.0))
                // 정전기 지수 상태바
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundStyle(Color.staticGray4)
                    Rectangle()
                        .foregroundStyle(Color.pointColor)
                        .frame(width: viewWidth * staticGuage)
                }
                .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
                .frame(height: 6)
            }
        }
        .frame(height: 50)
    }
    
    func limitMaxMin( _ num: Double) -> Double {
        var result = 0.0
        if num > 94 {
            result = 93
        } else if num < 4 {
            result = 5
        } else {
            return num
        }
        return result
    }
}

#Preview {
    StaticGuageProgressView(staticGuage: 96)
}
