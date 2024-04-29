//
//  AdView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/29/24.
//

import SwiftUI

struct AdView: View {
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel

    var body: some View {
        if !purchaseViewModel.isPurchased {
            AdMobBannerView()
                .initGADSize()
        }
    }
}

#Preview {
    AdView()
}
