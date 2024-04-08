//
//  File.swift
//  
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

import FirebaseFirestore
import FirebaseStorage

typealias FirebaseReturnTuple = (result: Bool, message: String)

@available(iOS 16.0.0, *)
class Firebase {
    /// 컬렉션 이름 정의
    enum CollectionName: String {
        case user = "Users"
    }
    
    /// Storage 이름 정의
    enum StorageName: String {
        case profile = "ProfileImages"
    }
    
    static let shared = Firebase()
    private let db = Firestore.firestore()
    
    // MARK: Public Properties
    
    // lazy var <#CollectionVariable#>: CollectionReference = db.collection(collection(<#Firebase.CollectionName#>))
    lazy var userCollection: CollectionReference = db.collection(collection(.user))
    lazy var storageReference = Storage.storage().reference()

    // MARK: Private Methods
    
    private func collection(_ collectionName: Firebase.CollectionName) -> String {
        return collectionName.rawValue
    }
    
    // MARK: Public Methods
    
    func profileImageUpload(uid: String, image: Data) async -> FirebaseReturnTuple {
        do {
            let profileReference = storageReference.child(StorageName.profile.rawValue).child(uid)
            let _ = try await profileReference.putDataAsync(image)
            let downloadURL = try await profileReference.downloadURL().absoluteString
            return (true, downloadURL)
        } catch {
            return (false, "프로필사진 업로드중 오류가 발생했습니다.")
        }
    }
}
