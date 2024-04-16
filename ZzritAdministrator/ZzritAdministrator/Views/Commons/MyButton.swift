//
//  MyButton.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/15/24.
//

import SwiftUI

struct MyButton: View {
    var named: String = "My Button"
    var width: CGFloat = .infinity
    var height: CGFloat = 50.0
    
    var features: () -> Void = {
        
    }
    
    var body: some View {
        Button {
            features()
        } label: {
            Text("\(named)")
                .foregroundStyle(.white)
                .font(.title2)
                .frame(idealWidth: width, maxWidth: .infinity)
                .frame(height: height)
                .background(Color.pointColor)
                .clipShape(.rect(cornerRadius: Constants.commonRadius))
        }
    }
}
