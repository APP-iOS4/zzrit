//
//  PurchaseView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/26/24.
//

import SwiftUI

struct PurchaseView: View {
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel
    var body: some View {
        VStack {
            Button {
                Task {
                    await purchaseViewModel.purchase(.oneMonth)
                }
            } label: {
                Text("1개월 구독하기")
                    .padding()
            }
            
            Button {
                Task {
                    await purchaseViewModel.purchase(.threeMonths)
                }
            } label: {
                Text("3개월 구독하기")
                    .padding()
            }
        }
        .task {
            await purchaseViewModel.purchasedProduct()
            print(purchaseViewModel.purchasedProduct ?? "구독 상품이 없다.")
        }
    }
}
