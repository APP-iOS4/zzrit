//
//  PurchaseService.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/22/24.
//

import Foundation
import StoreKit

import ZzritKit

typealias RestoreCompletion = (Bool) -> Void

class PurchaseService {
    enum SubscriptionType: String, CaseIterable {
        case oneMonth = "techit.finalproject.ZzritConsumer.pro.1month"
        case threeMonths = "techit.finalproject.ZzritConsumer.pro.3month"
    }
    
    // 프로덕트 목록
    let producdIds = SubscriptionType.allCases.map { $0.rawValue }
    
    private(set) var products: [Product] = []
    private var productsLoaded = false
    
    private(set) var currentSubscriptionType: String?
    
    private var updatesTask: Task<Void, Never>? = nil
    
    func loadProducts() async throws -> [Product] {
        let products = try await Product.products(for: producdIds)
        self.products = products
        return products
    }
    
    func loadPromotionalOffer() {
        products.forEach { product in
            if let discount = product.subscription?.promotionalOffers.first {
                Configs.printDebugMessage("discount: \(discount)")
            }
        }
    }
    
    @MainActor
    func purchase(_ productType: PurchaseService.SubscriptionType) async throws -> Bool {
        guard let index = products.firstIndex(where: {$0.id == productType.rawValue}) else { return false }

        let product = products[index ]
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            let _ = await self.updatePurchasedProducts()
            return true
        case .success(.unverified(_, _)):
            return false
        case .pending:
            return false
        case .userCancelled:
            Configs.printDebugMessage("유저가 결제를 취소했습니다.")
            return false
        @unknown default:
            Configs.printDebugMessage("알 수 없는 오류가 발생했습니다.")
            return false
        }
    }

    @MainActor
    func updatePurchasedProducts() async -> String? {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                return transaction.productID
            } else {
                return nil
            }
        }
        
        return nil
    }
    
    func startObservingTransactionUpdates() {
        updatesTask = Task(priority: .background) { [weak self] in
            for await _ in Transaction.updates {
                let _ = await self?.updatePurchasedProducts()
            }
        }
    }
    
    func stopObservingTransactionUpdates() {
        updatesTask?.cancel()
        updatesTask = nil
    }
    
    func restorePurchases(completion: @escaping RestoreCompletion) {
        Task {
            do {
                let _ = try await fetchPreviousPurchases()
                
                SKPaymentQueue.default().restoreCompletedTransactions()
                
                completion(true)
            } catch {
                completion(false)
                Configs.printDebugMessage("Failed to restore purchases: \(error)")
            }
        }
    }
    
    // 이전에 구매한 항목을 가져오는 메서드
    private func fetchPreviousPurchases() async throws -> [Product] {
        return []
    }
}
