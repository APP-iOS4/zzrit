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
        case term = "Terms"
        case chat = "Chatting"
        case ban = "BannedHistory"
    }
    
    private let db = Firestore.firestore()
    
    // MARK: Public Properties
    
    // lazy var <#CollectionVariable#>: CollectionReference = db.collection(collection(<#Firebase.CollectionName#>))
    lazy var userCollection: CollectionReference = db.collection(collection(.user))
    lazy var roomCollection: CollectionReference = db.collection(collection(.room))
    lazy var noticeCollection: CollectionReference = db.collection(collection(.notice))
    lazy var adminCollection: CollectionReference = db.collection(collection(.admin))
    lazy var contactCollection: CollectionReference = db.collection(collection(.contact))
    lazy var termCollection: CollectionReference = db.collection(collection(.term))
    lazy var banCollection: CollectionReference = db.collection(collection(.ban))
    
    // MARK: Public Methods
    
    public func joinedCollection(_ room: String) -> CollectionReference {
        return roomCollection.document(room).collection(collection(.joinedUser))
    }
    
    public func contactReplyCollection(_ contact: String) -> CollectionReference {
        return contactCollection.document(contact).collection(collection(.reply))
    }
    
    public func roomChatCollection(_ room: String) -> CollectionReference {
        return roomCollection.document(room).collection(collection(.chat))
    }
    
    /// FCM 메세지 전송
    /// - Warning: 절대적으로 실제 앱 배포시에는 별도의 백엔드 서버를 통하여 메세지를 전송해야함
    func sendMessage(to token: String, title: String, body: String) {
        guard let serverKey = Bundle.main.object(forInfoDictionaryKey: "FCM Server Key") as? String else { return }
        
        let urlString = "https://fcm.googleapis.com/fcm/send"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")

        let messageBody: [String: Any] = [
            "to": token,
            "notification": [
                "title": title,
                "body": body
            ],
            "data": [
                // Custom data payload
                "customData": "anythingYouWant"
            ]
        ]

        do {
            let data = try JSONSerialization.data(withJSONObject: messageBody, options: [])
            request.httpBody = data
        } catch {
            print("Error serializing message body: \(error.localizedDescription)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error sending message: \(error!.localizedDescription)")
                return
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
        }

        task.resume()
    }

    // MARK: Private Methods
    
    private func collection(_ collectionName: FirebaseConstants.CollectionName) -> String {
        return collectionName.rawValue
    }
    
}
