//
//  StaticGuageProgressView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

struct StaticGaugeProgressView: View {
    var staticGauge: Double
    // 말풍선 꼬리 아래 점 계산
    var downPoint: Double {
        var tempNum: Double
        if staticGauge < 8 {
            tempNum =  -((8 - staticGauge)  * 3.3)
        } else if staticGauge > 93 {
            tempNum = ((staticGauge - 93 ) * 3.3)
        } else {
            tempNum = 0
        }
        return tempNum
    }
    
    var body: some View {
        GeometryReader { geometry in
            let viewWidth = geometry.size.width / 100
            // 정전기 지수 풍선
            VStack {
                ZStack {
                    Text("\(String(format: "%.1f", staticGauge))W")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(7)
                        .frame(width: viewWidth * 18)
                        .background(Color.pointColor)
                        .clipShape(.rect(cornerRadius: Configs.cornerRadius))
                    
                    Triangle(points: [
                        CGPoint(x: viewWidth * 48, y: 27),
                        CGPoint(x: (viewWidth * 50) + downPoint, y: 42),
                        CGPoint(x: viewWidth * 54, y: 27)])
                    .fill(Color.pointColor)
                    
                }
                .position(CGPoint(x: viewWidth * limitMaxMin(staticGauge), y: 20.0))
                
                // 정전기 지수 상태바
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundStyle(Color.staticGray4)
                    Rectangle()
                        .foregroundStyle(Color.pointColor)
                        .frame(width: viewWidth * staticGauge)
                }
                .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
                .frame(height: 6)
            }
        }
        .frame(height: 50)
    }
    
    func limitMaxMin( _ num: Double) -> Double {
        var result = 0.0
        if num >= 93 {
            result = 93
        } else if num <= 8 {
            result = 8
        } else {
            return num
        }
        return result
    }
}

// 말풍선 꼬리 삼각형 그리기
struct Triangle: Shape {
    var points: [CGPoint]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: points[0])
        path.addLine(to: points[1])
        path.addLine(to: points[2])
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    NavigationStack {
        MoreInfoView()
    }
}
