//
//  PushService.swift
//
//
//  Created by Sanghyeon Park on 4/27/24.
//

import Foundation

import FirebaseFirestore

@available(iOS 16.0.0, *)
public class PushService {
    public static let shared = PushService()
    
    private let pushTokenRef = Firestore.firestore().collection("PushTokens")
    private let pushMessageRef = Firestore.firestore().collection("PushMessages")
    
    private init() { }
    
    public typealias NotificationData = [NotificationType: String]
    
    /// FCM 메세지 전송
    /// - Warning: 절대적으로 실제 앱 배포시에는 별도의 백엔드 서버를 통하여 메세지를 전송해야함
    public func pushMessage(targetUID: String, title: String, body: String, data: NotificationData) async {
        let urlString = "https://port-0-fcmnodejs-1pgyr2mlvhk7add.sel5.cloudtype.app/send-message"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataDic = ["\(data.keys.first!)", data.values.first!]

        if let tokens = await userTokens(uid: targetUID) {
            for token in tokens {
                let messageBody: [String: Any] = [
                    "token": token,
                    "title": title,
                    "body": body,
                    "data": dataDic
                ]
                
                do {
                    let data = try JSONSerialization.data(withJSONObject: messageBody, options: [])
                    request.httpBody = data
                    let (_, _) = try await URLSession.shared.data(for: request)
                } catch {
                    // 푸시메세지 전송 실패는 사용자에게 에러를 보여줄 정도로 중대한 오류라고 판단되지 않아 자체적으로 프린트로 대체합니다.
                    print("Error serializing message body: \(error.localizedDescription)")
                    return
                }
            }
            
            let messageData: PushMessageModel = .init(title: title, body: body, date: .now, targetUID: targetUID, senderUID: AuthenticationService.shared.currentUID ?? "", type: data.keys.first!, targetTypeID: data.values.first!)
            
            print("dataDic: \(dataDic)")
            addMessage(messageData)
        }
    }
    
    // MARK: - Token Methods
    
    /// 유저의 토큰정보를 불러옵니다.
    /// - Parameters:
    ///     - uid(String): 토큰을 불러올 유저의 uid
    /// - 토큰은 다중 기기에서 설정 될 수 있으므로 옵셔널의 배열로 반환합니다.
    func userTokens(uid: String) async -> [String]? {
        do {
            let document = try await pushTokenRef.document(uid).getDocument()
            let data = document.data()
            return data?["tokens"] as? [String]
        } catch {
            return []
        }
    }
    
    /// 유저의 토큰을 서버에 저장합니다.
    /// - Parameters:
    ///     - uid(String): 유저의 uid
    ///     - token(String): 저장할 토큰
    public func saveToken(_ uid: String, token: String) {
        print("saveToken 실행")
        pushTokenRef.document(uid).setData([
            "tokens": FieldValue.arrayUnion([token])
        ], merge: true)
    }
    
    /// 유저의 토큰을 서버에서 삭제합니다.
    ///  - Parameters:
    ///     - uid(String): 유저의 uid
    ///     - token(String): 저장할 토큰
    public func deleteToken(_ uid: String, token: String) {
        #if DEBUG
        print("토큰 삭제 실행")
        #endif
        pushTokenRef.document(uid).setData([
            "tokens": FieldValue.arrayRemove([token])
        ], merge: true)
    }
    
    // MARK: - MessageMethods
    
    private func addMessage(_ message: PushMessageModel) {
        do {
            try pushMessageRef.addDocument(from: message)
        } catch {
            #if DEBUG
            print("푸시 메세지 업로드 중 에러: \(error)")
            #endif
        }
    }
    
    public func allMessages() async throws -> [PushMessageModel] {
        guard let uid = AuthenticationService.shared.currentUID else {
            throw FirebaseErrorType.noSignIn
        }
        
        let snapshot = try await pushMessageRef.whereField("targetUID", isEqualTo: uid).getDocuments()
        let tempPushModelArray = try snapshot.documents.map { try $0.data(as: PushMessageModel.self) }
        
        // chat 혹은 room 타입은 3일 지나면 삭제됨
        return tempPushModelArray.filter { pushMessageModel in
            if pushMessageModel.type == .chat || pushMessageModel.type == .room {
                
                // 3일 전 (5월 1일이라면, 4월 28일 00시 00분 00초)을 구하는 코드
                guard let threeDaysBefore = Calendar.current.date(
                    bySettingHour: 0, minute: 0, second: 0, of: Calendar.current.date(byAdding: .day, value: -3, to: Date())!
                ) else {
                    return true
                }
                
                // 3일 전보다 더 빠르다면, 메세지를 삭제 후 필터링으로 제거
                if pushMessageModel.date < threeDaysBefore {
                    pushMessageRef.document(pushMessageModel.id).delete()
                    return false
                } else {
                    return true
                }
            }
            return true
        }
    }
    
    public func readMessage(messageID: String) {
        pushMessageRef.document(messageID).setData(["readDate": Date()], merge: true)
    }
    
}
