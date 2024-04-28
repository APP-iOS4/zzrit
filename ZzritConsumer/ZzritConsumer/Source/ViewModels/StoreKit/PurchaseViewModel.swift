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
    
    /// 결제화면을 보이기 위한 변수
    @Published var isPresent: Bool = false
    /// 구매 가능한 구독 상품 목록
    @Published private(set) var products: [Product] = []
    /// 구매가 완료된 구독 상품
    @Published private(set) var purchasedProduct: String? = nil
    
    var isPurchased: Bool {
        if let count = purchasedProduct?.count {
            return count > 0 ? true : false
        }
        return false
    }
    
    init() {
        Task {
            await syncProducts()
            purchasedProduct = await purchaseService.updatePurchasedProducts()
            print("purchasedProduct: \(purchasedProduct)")
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
    func purchase(_ productType: PurchaseService.SubscriptionType) async throws -> Bool {
        return try await purchaseService.purchase(productType)
    }
    
    /// 현재 구독중인 상품을 불러옵니다.
    func purchasedProduct() async {
        self.purchasedProduct = await purchaseService.updatePurchasedProducts()
    }
    
    /// 스토어 구매를 옵저빙 합니다.
    func startObservingTransactionUpdates() {
        purchaseService.startObservingTransactionUpdates()
    }
    
    /// 해당 구독 상품을 불러옵니다.
    func product(_ type: PurchaseService.SubscriptionType) -> Product? {
        guard let index = products.firstIndex(where: {$0.id == type.rawValue}) else { return nil }
        return products[index]
    }
    
    /// 결제화면뷰 토글
    func togglePresent() {
        isPresent.toggle()
    }
}
