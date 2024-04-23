//
//  RestrictionViewModel.swift
//  ZzritConsumer
//
//  Created by 이우석 on 4/22/24.
//

import Foundation

import ZzritKit

@MainActor
class RestrictionViewModel: ObservableObject {
    private let userManageService = UserManageService()
    private let userService = UserService()
    
    @Published var restrictionHistory: [BannedModel] = [] // 전체 제재 이력
    @Published var currentRestriction: [BannedModel] = [] // 현재 제재 이력

    // 제재 이력 가져오기
    func loadRestriction(userID: String) {
        Task {
            do {
                restrictionHistory = []
                currentRestriction = []
                restrictionHistory = try await userManageService.loadRestrictions(userID: userID)
                currentRestriction = restrictionHistory.filter{ $0.period > Date() }
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    // 현재 제재중인지 여부
    var isUnderRestriction: Bool {
        if currentRestriction.isEmpty {
            return false
        } else {
            return true
        }
    }
}
