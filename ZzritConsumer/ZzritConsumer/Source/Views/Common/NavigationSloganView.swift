//
//  NavigationSloganView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/28/24.
//

import SwiftUI

struct NavigationSloganView: View {
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            Text("ZZ!")
                .foregroundStyle(Color.pointColor)
            Text("RIT")
            
            Image(systemName: "star.circle.fill")
                .font(.body)
                .padding(5)
                .foregroundStyle(purchaseViewModel.isPurchased ? Color.pointColor : Color.staticGray5)
                .onTapGesture {
                    if !purchaseViewModel.isPurchased {
                        purchaseViewModel.isPresent.toggle()
                    }
                }
        }
        .font(.title2)
        .fontWeight(.black)
    }
}
