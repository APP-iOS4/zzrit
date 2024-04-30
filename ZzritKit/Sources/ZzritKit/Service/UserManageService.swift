//
//  File.swift
//
//
//  Created by woong on 4/15/24.
//

import Foundation

import FirebaseFirestore

@available(iOS 16.0, *)
public final class UserManageService {
    private let fbConstant = FirebaseConstants()
    private let authService = AuthenticationService.shared
    private let dateService = DateService.shared
    
    private let db = Firestore.firestore()
    
    public init() { }
    
    // 관리자id, 유저id
    public func registerUserRestriction(userID uid: String, adminID aid: String, bannedType: BannedType, period: Date, content: String) throws {
        do {
            let tempBannedModel = BannedModel(date: Date(), period: period, type: bannedType, adminID: aid, content: content)
            try fbConstant.userCollection.document(uid).collection("BannedHistory").addDocument(from: tempBannedModel)
            
            Task {
                // 메시지 보내기
                await PushService.shared.pushMessage(targetUID: uid, title: "ZZ!RIT 제재 안내",
                                                     body: bannedType == .administrator ? "\(dateService.formattedString(date: period, format: "yyyy년 M월 d일"))까지 서비스 이용이 정지되었습니다. 자세한 사항은 제재 내역을 확인해 주세요. " : "\(bannedType.rawValue) 행위로 인해 \(dateService.formattedString(date: period, format: "yyyy년 M월 d일"))까지 서비스 이용이 정지되었습니다. 자세한 사항은 제재 내역을 확인해 주세요. ", data: [.banned: ""])
            }
        } catch {
            throw error
        }
    }
    
    // 관리자id, 유저id
    public func deleteUserRestriction(userID uid: String, bannedHistoryId bId: String) {
        fbConstant.userCollection.document(uid).collection("BannedHistory").document(bId).getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let document = document {
                if document.exists {
                    self.fbConstant.userCollection.document(uid).collection("BannedHistory").document(bId).delete()
                    Task {
                        if let getToken = await PushService.shared.userTokens(uid: uid) {
                            for token in getToken {
                                // 메시지 보내기
                                await PushService.shared.pushMessage(targetUID: token, title: "ZZ!RIT 제재 해제 안내", body: "서비스 이용 정지가 해제되었습니다. ", data: [.banned: ""])
                            }
                        }
                    }
                } else {
                    print("삭제할 문서가 없음.")
                }
            }
        }
    }
    
    // 관리자id?, 유저id
    public func adjustUserScore(userID uid: String, score: Int) throws {
        fbConstant.userCollection.document(uid).updateData(["staticGauge": score])
    }
    
    // 유저id
    public func changeUserEmail(userID uid: String, newEmail: String) {
        fbConstant.userCollection.document(uid).updateData(["userID": newEmail])
    }
    
    public func loadRestrictions(userID uid: String) async throws -> [BannedModel] {
        let query = fbConstant.userCollection.document(uid).collection("BannedHistory")
        do {
            let snapshot = try await query.getDocuments()
            let documents = snapshot.documents
            var bannedmodels: [BannedModel] = []
            for document in documents {
                bannedmodels.append(try document.data(as: BannedModel.self))
            }
            return bannedmodels
        } catch {
            throw FirebaseErrorType.failLoadRestrictions
        }
    }
    
    public func loadAllUsers() async throws -> [UserModel] {
        let query = fbConstant.userCollection
        do {
            let snapshot = try await query.getDocuments()
            let documents = snapshot.documents
            var userModels: [UserModel] = []
            for document in documents {
                userModels.append(try document.data(as: UserModel.self))
            }
            return userModels
        } catch {
            throw FirebaseErrorType.failLoadUsers
        }
    }
}
