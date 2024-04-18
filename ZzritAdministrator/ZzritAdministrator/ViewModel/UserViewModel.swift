//
//  UserViewModel.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/17/24.
//

import Foundation

import ZzritKit

@MainActor
class UserViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var restrictionHistory: [BannedModel] = []
    
    private let userService = UserService()
    private let userManageService = UserManageService()
    
    init() {
        loadUsers()
    }
    
    func loadUsers() {
        Task {
            do {
                users = try await userManageService.loadAllUsers()
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    func loadBannedHistory(userID: String) {
        Task {
            do {
                restrictionHistory = []
                restrictionHistory = try await userManageService.loadRestrictions(userID: userID)
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    func editScore(userID: String, score: Int) {
        Task {
            do {
                try userManageService.adjustUserScore(userID: userID, score: score)
                
                loadUsers()
                
                if let index = users.firstIndex(where: { $0.id == userID }) {
                    users[index].staticGauge = Double(score)
                }
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    func startRestriction(userID: String, type: BannedType, period: Int, content: String) {
        Task {
            do {
                if let adminID = try await userService.loginedAdminInfo()?.id {
                    try userManageService.registerUserRestriction(userID: userID, adminID: adminID, bannedType: type, period: Date().addingTimeInterval(TimeInterval(period) * 86400), content: content)
                    
                    loadBannedHistory(userID: userID)
                    
                    if let index = users.firstIndex(where: { $0.id == userID }) {
                        if let bannedHistory = users[index].bannedHistory {
                            var tempRestriction: [BannedModel] = bannedHistory
                            tempRestriction.append(BannedModel(date: Date(), period: Date().addingTimeInterval(TimeInterval(period) * 86400), type: type, adminID: adminID, content: content))
                        }
                    }
                }
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    func deleteRestriction(userID: String, restrictionID ban: String) {
        Task {
            do {
                if (try await userService.loginedAdminInfo()?.id) != nil {
                    userManageService.deleteUserRestriction(userID: userID, bannedHistoryId: ban)
                }
                
                // loadBannedHistory(userID: userID)
                
                if let index = users.firstIndex(where: { $0.id == userID }) {
                    if let bannedHistory = users[index].bannedHistory {
                        var tempRestriction: [BannedModel] = bannedHistory
                        if let banIndex = tempRestriction.firstIndex(where: { $0.id == ban }) {
                            tempRestriction.remove(at: banIndex)
                        }
                    }
                }
            } catch {
                print("에러: \(error)")
            }
        }
    }
}
