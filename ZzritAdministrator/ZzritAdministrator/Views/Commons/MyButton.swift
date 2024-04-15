//
//  MyButton.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/15/24.
//

import SwiftUI

struct MyButton: View {
    var named: String = "My Button"
    
    var features: () -> Void = {
        print("My Button Features!!")
    }
    
    var width: CGFloat = .infinity
    var height: CGFloat = 50.0
    
    var body: some View {
        Button {
            features()
        } label: {
            Text("\(named)")
                .foregroundStyle(.white)
                .font(.title2)
                .frame(minWidth: 300.0, maxWidth: .infinity)
                .frame(height: 50.0)
                .background(Color.pointColor)
                .clipShape(.rect(cornerRadius: Constants.commonRadius))
        }
    }
}
