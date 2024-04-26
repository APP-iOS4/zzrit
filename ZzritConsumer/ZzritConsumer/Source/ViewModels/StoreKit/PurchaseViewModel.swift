//
//  PurchaseViewModel.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/26/24.
//

import Foundation
import StoreKit

@MainActor
class PurchaseViewModel: ObservableObject {
    private let purchaseService = PurchaseService()
    
    /// 구매 가능한 구독 상품 목록
    @Published private(set) var products: [Product] = []
    /// 구매가 완료된 구독 상품
    @Published private(set) var purchasedProduct: String? = nil
    
    init() {
        Task {
            await syncProducts()
            purchasedProduct = await purchaseService.updatePurchasedProducts()
        }
    }
    
    /// 앱스토어 커넥트의 구독상품을 모두 동기화 합니다.
    private func syncProducts() async {
        do {
            products = try await purchaseService.loadProducts()
        } catch {
            print("구독 상품을 불러오는 도중 오류가 발생했습니다.: \(error)")
        }
    }
    
    /// 구독 상품을 구매합니다.
    func purchase(_ productType: PurchaseService.SubscriptionType) async -> Bool {
        do {
            return try await purchaseService.purchase(productType)
        } catch {
            print("구매 도중 오류가 발생했습니다. \(error)")
            return false
        }
    }
    
    /// 현재 구독중인 상품을 불러옵니다.
    func purchasedProduct() async {
        self.purchasedProduct = await purchaseService.updatePurchasedProducts()
    }
    
    /// 스토어 구매를 옵저빙 합니다.
    func startObservingTransactionUpdates() {
        purchaseService.startObservingTransactionUpdates()
    }
    
}
