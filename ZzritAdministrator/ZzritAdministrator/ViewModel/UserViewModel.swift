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
                print(userID)
                restrictionHistory = []
                if let bannedHistory = try await userService.getUserInfo(uid: userID)?.bannedHistory {
                    restrictionHistory = bannedHistory
                    print(restrictionHistory)
                } else {
                    print("정보 없음")
                }
                
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    func editScore(userID: String, score: Int) {
        Task {
            do {
                try userManageService.adjustUserScore(userID: userID, score: score)
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
                }
            } catch {
                print("에러: \(error)")
            }
        }
    }
}
