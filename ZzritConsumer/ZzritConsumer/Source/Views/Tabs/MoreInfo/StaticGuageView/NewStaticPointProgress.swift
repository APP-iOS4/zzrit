//
//  NewStaticPointProgress.swift
//  ZzritConsumer
//
//  Created by SunJoon Lee on 4/28/24.
//

import SwiftUI

struct NewStaticPointProgress: View {
    let staticPoint: Double
    @State private var textSize: CGSize = CGSize()
    
    var body: some View {
        GeometryReader { globalProxy in
            let barPositionX = globalProxy.size.width * CGFloat(staticPoint) / 100
            
            var textPositionX: CGFloat {
                if barPositionX < (textSize.width / 2) {
                    return textSize.width / 2
                } else if barPositionX > (globalProxy.size.width - (textSize.width / 2)) {
                    return globalProxy.size.width - (textSize.width / 2)
                } else {
                    return barPositionX
                }
            }
            
            VStack(spacing: 0.0) {
                Text("\(String(format: "%.1f", staticPoint)) W")
                    .bold()
                    .padding(.vertical, 5.0)
                    .padding(.horizontal, 10.0)
                    .background {
                        RoundedRectangle(cornerRadius: 20.0)
                            .fill(Color.pointColor)
                        
                        GeometryReader { textProxy in
                            Path { _ in
                                DispatchQueue.main.async {
                                    self.textSize = textProxy.size
                                }
                            }
                        }
                    }
                    .offset(x: textPositionX - globalProxy.size.width / 2)
                
                Triangle(points: [
                    CGPoint(x: textPositionX - 10, y: 0),
                    CGPoint(x: textPositionX + 10, y: 0),
                    CGPoint(x: barPositionX, y: 8)
                ])
                .fill(Color.pointColor)
                .frame(height: 8)
                
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.pointColor)
                        .frame(width: barPositionX, height: 10.0)
                    
                    Rectangle()
                        .strokeBorder(Color.staticGray4, lineWidth: 1.0)
                        .frame(height: 10.0)
                }
            }
            .position(x: globalProxy.size.width / 2, y: globalProxy.size.height / 2)
        }
        .frame(minHeight: textSize.height + 30)
    }
}

#Preview {
    NewStaticPointProgress(staticPoint: 20.0)
}
