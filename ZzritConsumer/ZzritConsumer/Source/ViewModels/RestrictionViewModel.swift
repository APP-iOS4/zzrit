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
    
    func getPenalty(from start: Date, to end: Date) -> Int {
        let banPeriod = Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0
        
        let penalty: Int = switch banPeriod {
        case ...3:
            -1
        case 4...5:
            -2
        case 6...7:
            -3
        case 8...14:
            -5
        case 15...30:
            -10
        case 31...180:
            -20
        case 181...365:
            -30
        case 366...:
            -100
        default:
            0
        }
        
        return penalty
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
