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
    
    private let pushRef = Firestore.firestore().collection("PushTokens")
    
    private init() { }
    
    /// FCM 메세지 전송
    /// - Warning: 절대적으로 실제 앱 배포시에는 별도의 백엔드 서버를 통하여 메세지를 전송해야함
    public func pushMessage(to token: String, title: String, body: String) async {
        let urlString = "https://port-0-fcmnodejs-1pgyr2mlvhk7add.sel5.cloudtype.app/send-message"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let messageBody: [String: Any] = [
            "token": token,
            "title": title,
            "body": body
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
    
    /// 유저의 토큰정보를 불러옵니다.
    /// - Parameters:
    ///     - uid(String): 토큰을 불러올 유저의 uid
    /// - 토큰은 다중 기기에서 설정 될 수 있으므로 옵셔널의 배열로 반환합니다.
    public func userTokens(uid: String) async -> [String]? {
        do {
            let document = try await pushRef.document(uid).getDocument()
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
        pushRef.document(uid).setData([
            "tokens": FieldValue.arrayUnion([token])
        ], merge: true)
    }
}
