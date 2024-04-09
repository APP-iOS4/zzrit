//
//  FirebaseConstants.swift
//
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

import FirebaseFirestore

@available(iOS 16.0.0, *)
final class FirebaseConstants {
    /// 컬렉션 이름 정의
    enum CollectionName: String {
        case user = "Users"
        case room = "Rooms"
        case notice = "Notices"
    }
    
    private let db = Firestore.firestore()
    
    // MARK: Public Properties
    
    // lazy var <#CollectionVariable#>: CollectionReference = db.collection(collection(<#Firebase.CollectionName#>))
    lazy var userCollection: CollectionReference = db.collection(collection(.user))
    lazy var roomCollection: CollectionReference = db.collection(collection(.room))
    lazy var noticeCollection: CollectionReference = db.collection(collection(.notice))

    
    // MARK: Private Methods
    
    private func collection(_ collectionName: FirebaseConstants.CollectionName) -> String {
        return collectionName.rawValue
    }
    
    // MARK: Public Methods
    
    func imageUpload(dirs: [String], image: Data) async throws -> String {
        do {
            var rf = storageReference
            
            for dir in dirs {
                rf = rf.child(dir)
            }
            
            let _ = try await rf.putDataAsync(image)
            let downloadURL = try await rf.downloadURL().absoluteString
            return downloadURL
        } catch {
            throw error
        }
    }
}
