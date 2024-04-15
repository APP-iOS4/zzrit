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
    
    private let db = Firestore.firestore()
    
    public init() { }
    
    // TODO: 유저 제제 등록
    // 관리자id, 유저id
    public func registerUserRestriction(userID uid: String, adminID aid: String, bannedType: BannedType, period: Date) throws {
        do {
            let tempBannedModel = BannedModel(date: Date(), period: period, type: bannedType, adminID: aid)
            try fbConstant.userCollection.document(uid).collection("BannedHistory").addDocument(from: tempBannedModel)

        } catch {
            throw error
        }
    }
    
    // TODO: 유저 제재 삭제
    // 관리자id, 유저id
    public func deleteUserRestriction(userID uid: String, bannedHistoryId bId: String) {
        fbConstant.userCollection.document(uid).collection("BannedHistory").document(bId).getDocument { document, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let document = document {
                if document.exists {
                    self.fbConstant.userCollection.document(uid).collection("BannedHistory").document(bId).delete()
                } else {
                    print("삭제할 문서가 없음.")
                }
                
            }
        }
    }
    
    // TODO: 유저 정전기 지수 수정
    // 관리자id?, 유저id
    public func adjustUserScore(userID uid: String, score: Int) throws {
        fbConstant.userCollection.document(uid).updateData(["staticGauge": score])
    }
    
    // TODO: 유저 이메일 변경
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
}
