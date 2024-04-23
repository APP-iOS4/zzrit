//
//  PurchaseService.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/22/24.
//

import Foundation
import StoreKit

import ZzritKit

enum ProductType {
    case monthly
    case yearly
}

enum PurchaseError: Error {
    case noProduct
}

typealias RestoreCompletion = (Bool) -> Void

class PurchaseStore: ObservableObject {
    static let shared = PurchaseStore()
    
    // 프로덕트 목록
    let producdIds = [
        "techit.finalproject.ZzritConsumer.pro.1month",
        "techit.finalproject.ZzritConsumer.pro.3month",
    ]
    
    @Published private(set) var products: [Product] = []
    private var productsLoaded = false
    
    private(set) var currentSubscriptionType: String?
    
    @Published private(set) var purchasedProductIDs = Set<Transaction>()
    var hasUnlockedPro: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    private var updatesTask: Task<Void, Never>? = nil
    
    // Public Properties
//    @Published var isSubscribed: Bool = false
    var isSubscribed: Bool {
        return purchasedProductIDs.count > 0
    }
    
    private init() {
        Task {
            try await loadProducts()
            await updatePurchasedProducts()
            Configs.printDebugMessage("All Products ------\n\(products)")
            Configs.printDebugMessage("Localized Price ------\n")
            products.forEach { product in
                Configs.printDebugMessage(product.displayPrice)
            }
            Configs.printDebugMessage("Purchased Products -----\n\(purchasedProductIDs)")
        }
    }
    
    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: producdIds)
        self.productsLoaded = true
        loadPromotionalOffer()
    }
    
    func loadPromotionalOffer() {
        products.forEach { product in
            if let discount = product.subscription?.promotionalOffers.first {
                Configs.printDebugMessage("discount: \(discount)")
            }
        }
    }
    
    @MainActor
    func purchase(_ product: Product, completion: @escaping (Bool) -> Void) async throws {
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await self.updatePurchasedProducts()
            completion(true)
        case .success(.unverified(_, _)):
            completion(false)
            break
        case .pending:
            break
        case .userCancelled:
            Configs.printDebugMessage("유저가 결제를 취소함")
            completion(false)
            break
        @unknown default:
            Configs.printDebugMessage("알 수 없는 오류")
            completion(false)
            break
        }
    }

    @MainActor
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction)
                self.currentSubscriptionType = transaction.productID
            } else {
                self.purchasedProductIDs.remove(transaction)
            }
        }
    }
    
    func startObservingTransactionUpdates() {
        updatesTask = Task(priority: .background) { [weak self] in
            for await _ in Transaction.updates {
                await self?.updatePurchasedProducts()
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
