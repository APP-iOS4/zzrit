//
//  InformationView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/23/24.
//

import SwiftUI

struct InformationView<Content: View>: View {
    
    let buttonTitle: String
    let content: () -> Content
    let buttonAction: () -> ()
    
    var body: some View {
        VStack {
            Spacer()
            Image("ZziritLogoImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
            
            content()
            
            Spacer()
            
            HStack {
                GeneralButton(buttonTitle) {
                    buttonAction()
                }
            }
            .padding(Configs.paddingValue)
        }
    }
}

#Preview {
    InformationView(buttonTitle: "로그인") {
        Text("테스트 문구")
    } buttonAction: {
        
    }
}
