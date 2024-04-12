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
        case joinedUser = "JoinedUsers"
        case admin = "AdminUsers"
        case contact = "Contacts"
        case reply = "Replies"
    }
    
    private let db = Firestore.firestore()
    
    // MARK: Public Properties
    
    // lazy var <#CollectionVariable#>: CollectionReference = db.collection(collection(<#Firebase.CollectionName#>))
    lazy var userCollection: CollectionReference = db.collection(collection(.user))
    lazy var roomCollection: CollectionReference = db.collection(collection(.room))
    lazy var noticeCollection: CollectionReference = db.collection(collection(.notice))
    lazy var adminCollection: CollectionReference = db.collection(collection(.admin))
    lazy var contactCollection: CollectionReference = db.collection(collection(.contact))
    
    // MARK: Public Methods
    
    public func joinedCollection(_ room: String) -> CollectionReference {
        return roomCollection.document(room).collection(collection(.joinedUser))
    }
    
    public func contactReplyCollection(_ contact: String) -> CollectionReference {
        return contactCollection.document(contact).collection(collection(.reply))
    }

    // MARK: Private Methods
    
    private func collection(_ collectionName: FirebaseConstants.CollectionName) -> String {
        return collectionName.rawValue
    }
    
}
