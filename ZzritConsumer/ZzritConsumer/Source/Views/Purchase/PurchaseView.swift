//
//  PurchaseView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/26/24.
//

import SwiftUI

struct PurchaseView: View {
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel
    
    @State private var isPurchasing: Bool = false
    @State private var isShowingAlert: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 10) {
                Image("Ririt/Purchase")
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(height: 200)
                    .padding(.bottom, 10)
                
                Text("만남을 더 특별하게")
                    .font(.title3)
                    .fontWeight(.black)
                    .foregroundStyle(Color.staticGray1)
                
                HStack {
                    Text("ZZ!RIT")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundStyle(Color.pointColor)
                    
                    Text("Pro")
                        .font(.body)
                        .fontWeight(.black)
                        .foregroundStyle(.white)
                        .padding(5)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.pointColor)
                        }
                }
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("혜택 1")
                        .font(.title3.bold())
                        .foregroundStyle(Color.pointColor)
                    Text("광고없이 필요한 정보만 볼 수 있어요.")
                }
              
                VStack(alignment: .leading, spacing: 10) {
                    Text("혜택 2")
                        .font(.title3.bold())
                        .foregroundStyle(Color.pointColor)
                    Text("횟수제한 없이 모임을 개설할 수 있어요.")
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("혜택 3")
                        .font(.title3.bold())
                        .foregroundStyle(Color.pointColor)
                    Text("모임 개설시 참여 조건을 설정할 수 있어요.")
                }
            }
            
            Spacer()
            
            VStack(spacing: 10) {
                GeneralButton("3개월 구독 (\(purchaseViewModel.product(.threeMonths)?.displayPrice ?? "가격정보 없음"))") {
                    purchase(.threeMonths)
                }
                Button {
                    purchase(.oneMonth)
                } label: {
                    Text("1개월 구독 (\(purchaseViewModel.product(.oneMonth)?.displayPrice ?? "가격정보 없음"))")
                        .padding()
                }
            }
            .padding(Configs.paddingValue)
        }
        .loading(isPurchasing, message: "결제가 진행중입니다.")
        .task {
            await purchaseViewModel.purchasedProduct()
            print(purchaseViewModel.purchasedProduct ?? "구독 상품이 없다.")
        }
    }
    
    private func purchase(_ product: PurchaseService.SubscriptionType) {
        isPurchasing.toggle()
        
        Task {
            do {
                let result = try await purchaseViewModel.purchase(product)
                if !result {
                    isShowingAlert = true
                }
                isPurchasing.toggle()
            } catch {
                isShowingAlert = true
                isPurchasing.toggle()
            }
        }
    }
}

#Preview {
    PurchaseView()
        .environmentObject(PurchaseViewModel())
}
