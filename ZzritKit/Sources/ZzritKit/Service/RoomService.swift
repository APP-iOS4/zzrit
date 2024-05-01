//
//  File.swift
//
//
//  Created by woong on 4/8/24.
//

import CoreLocation
import Foundation

import FirebaseFirestore

@available(iOS 16.0, *)
public final class RoomService {
    public static let shared = RoomService()
    let fbConstants = FirebaseConstants()
    
    private var lastSnapshot: QueryDocumentSnapshot? = nil
    private var lastSnapshotForSearch: QueryDocumentSnapshot? = nil
    // 쿼리를 아끼기 위해 존재. 검색했을때 나와줄 친구들.
    var tempRooms: [RoomModel] = []
    
    private var isFetchEnd: Bool = false
    private var isFetchEndSearch: Bool = false
    
    /**
     # Description
     - 모임 추가를 위한 메서드
     # Parameters
     - room: RoomModel
     # Error
     - FirebaseErrorType.failCreateRoom
     */
    public func createRoom(_ room: RoomModel) async throws -> String {
        do {
            // TODO: 빈칸 있으면 에러.(소비자앱과 상의 필.)
            let result = try fbConstants.roomCollection.addDocument(from: room)
            try await joinRoom(result.documentID)
            //쿼리를 아끼기 위한 append
            tempRooms.append(room)
            return result.documentID
            // TODO: 모임 참여 await
        } catch {
            throw FirebaseErrorType.failCreateRoom
        }
    }
    
    /**
     # Description
     - 모임 불러오기를 위한 메서드
     # Parameters
     - isInitial: Bool
     - status: String(all, deactivation, activation / all일땐 아무런 영향없음.)
     - title: String? = nil
     # Error
     - FirebaseErrorType.failCreateRoom
     */
    public func loadRoom(isInitial: Bool = true, status: String = "all", title: String? = nil, coordinate: CLLocationCoordinate2D? = nil) async throws -> [RoomModel] {
        var temp: [RoomModel] = []
        
        do {
            if isInitial {
                lastSnapshot = nil
                isFetchEnd = false
            }
            
            if isFetchEnd {
                print("더이상 갖고올 데이터가 없음.")
                throw FirebaseErrorType.noMoreSearching
            }
            
            var query = fbConstants.roomCollection.limit(to: 16)
            
            if status == "deactivation" {
                query = fbConstants.roomCollection
                    .whereField("status", isEqualTo: "deactivation")
            } else if status == "activation" {
                query = fbConstants.roomCollection
                    .whereField("status", isEqualTo: "activation")
            }
            
            if let coordinate {
                // 오프라인 모임 검색일 경우
                // LocationService에 저장되어 있는 위도 경도 범위로 모임 검색
                SearchLocationService.shared.setLocation(coordinate)
                let locationRange = SearchLocationService.shared.locationRange
                query = query.whereField("placeLatitude", isGreaterThanOrEqualTo: locationRange.minLatitude)
                query = query.whereField("placeLatitude", isLessThanOrEqualTo: locationRange.maxLatitude)
                query = query.whereField("placeLongitude", isGreaterThanOrEqualTo: locationRange.minLongitude)
                query = query.whereField("placeLongitude", isLessThanOrEqualTo: locationRange.maxLongitude)
            } else {
                query = query.whereField("isOnline", isEqualTo: true)
            }
            
            if let titleString = title, titleString != "" {
                
                query = query.whereField("title", isGreaterThanOrEqualTo: titleString)
                    .whereField("title", isLessThan: titleString + "힣")
                
                let snapshot = try await query.getDocuments()
                let documents = try snapshot.documents.map { try $0.data(as: RoomModel.self)}
                
                temp.append(contentsOf: documents)
                print("isEqualTo: \(documents)")
                print(documents)
                
                return temp
                
            } else if let titleString = title, titleString == "" {
                
                if !isInitial, let lastDocument = lastSnapshot {
                    query = query.start(afterDocument: lastDocument)
                }
                
                let snapshot = try await query.getDocuments()
                let documents = try snapshot.documents.map { try $0.data(as: RoomModel.self)}
                
                lastSnapshot = snapshot.documents.last
                
                if lastSnapshot == nil {
                    isFetchEnd = true
                    //                throw FirebaseErrorType.noMoreSearching
                }
                print(documents)
                
                return documents
            } else if title == nil {
                if !isInitial, let lastDocument = lastSnapshot {
                    query = query.start(afterDocument: lastDocument)
                }
                
                let snapshot = try await query.getDocuments()
                let documents = try snapshot.documents.map { try $0.data(as: RoomModel.self)}
                
                lastSnapshot = snapshot.documents.last
                
                if lastSnapshot == nil {
                    isFetchEnd = true
                    //                throw FirebaseErrorType.noMoreSearching
                }
                print(documents)
                
                return documents
            }
            
            // 위에서 에러 발생시 맨위에 임의로 만들어놓은 offlineRoomModel이 반환됨.
            return []
        } catch {
            //            throw FirebaseErrorType.failLoadRoom
            throw error
        }
        
        // 필터가 있는 경우
        // 검색탭에서 필터링된 쿼리 만들기
        // 제목으로 필터링하는 부분 나중에 다시 사용할 수도있어서 일단은 주석처리했습니다.
        //            if title != "" {
        //                // title이 있다면
        //                query = query.whereField("title", isEqualTo: title!)
        //            }
    }
    
    // 탐색탭 필터
    public func searchLoadRoom(isInitial: Bool = true, status: String = "all", title: String? = nil, isOnline: Bool? = nil, coordinate: CLLocationCoordinate2D? = nil) async throws -> [RoomModel] {
        var temp: [RoomModel] = []
        
        do {
            if isInitial {
                lastSnapshotForSearch = nil
                isFetchEndSearch = false
            }
            
            if isFetchEndSearch {
                print("더이상 갖고올 데이터가 없음.")
                throw FirebaseErrorType.noMoreSearching
            }
            
            var query = fbConstants.roomCollection.limit(to: 16)
            
            if status == "deactivation" {
                query = fbConstants.roomCollection
                    .whereField("status", isEqualTo: "deactivation")
            } else if status == "activation" {
                query = fbConstants.roomCollection
                    .whereField("status", isEqualTo: "activation")
            }
            
            if let isOnline {
                if isOnline {
                    query = query.whereField("isOnline", isEqualTo: true)
                } else {
                    //                    query = query.whereField("isOnline", isEqualTo: false)
                    
                    if let coordinate {
                        // 오프라인 모임 검색일 경우
                        // LocationService에 저장되어 있는 위도 경도 범위로 모임 검색
                        SearchLocationService.shared.setLocation(coordinate)
                        let locationRange = SearchLocationService.shared.locationRange
                        query = query.whereField("placeLatitude", isGreaterThanOrEqualTo: locationRange.minLatitude)
                        query = query.whereField("placeLatitude", isLessThanOrEqualTo: locationRange.maxLatitude)
                        query = query.whereField("placeLongitude", isGreaterThanOrEqualTo: locationRange.minLongitude)
                        query = query.whereField("placeLongitude", isLessThanOrEqualTo: locationRange.maxLongitude)
                    }
                }
            }
            
            if let titleString = title, titleString != "" {
                
                query = query.whereField("title", isGreaterThanOrEqualTo: titleString)
                    .whereField("title", isLessThan: titleString + "힣")
                
                let snapshot = try await query.getDocuments()
                let documents = try snapshot.documents.map { try $0.data(as: RoomModel.self)}
                
                temp.append(contentsOf: documents)
                print("isEqualTo: \(documents)")
                print(documents)
                
                return temp
                
            } else if let titleString = title, titleString == "" {
                
                if !isInitial, let lastDocument = lastSnapshotForSearch {
                    query = query.start(afterDocument: lastDocument)
                }
                
                let snapshot = try await query.getDocuments()
                let documents = try snapshot.documents.map { try $0.data(as: RoomModel.self)}
                
                lastSnapshotForSearch = snapshot.documents.last
                
                if lastSnapshotForSearch == nil {
                    isFetchEndSearch = true
                    //                throw FirebaseErrorType.noMoreSearching
                }
                print(documents)
                
                return documents
            } else if title == nil {
                if !isInitial, let lastDocument = lastSnapshotForSearch {
                    query = query.start(afterDocument: lastDocument)
                }
                
                let snapshot = try await query.getDocuments()
                let documents = try snapshot.documents.map { try $0.data(as: RoomModel.self)}
                
                lastSnapshotForSearch = snapshot.documents.last
                
                if lastSnapshotForSearch == nil {
                    isFetchEndSearch = true
                    //                throw FirebaseErrorType.noMoreSearching
                }
                print(documents)
                
                return documents
            }
            
            // 위에서 에러 발생시 맨위에 임의로 만들어놓은 offlineRoomModel이 반환됨.
            return []
        } catch {
            //            throw FirebaseErrorType.failLoadRoom
            throw error
        }
    }
    
    // FIXME: setData에서 updateData로 수정해야함.
    /// 모임 내용을 변경합니다.
    ///  - Parameter room: 수정된 RoomModel
    ///  - Parameter roomID(String): 변경할 모임 ID
    public func modifyRoom(_ room: RoomModel, roomID: String) throws {
        //        fbConstants.roomCollection.document(roomID).setData(room)
        try fbConstants.roomCollection.document(roomID).setData(from: room)
    }
    
    /// 모임 상태를 변경합니다.
    ///  - Parameter roomID(String): 변경할 모임 ID
    ///  - Parameter status(ActiveType): 변경할 상태
    public func changeStatus(roomID: String, status: ActiveType) {
        fbConstants.roomCollection.document(roomID).setData(["status": status.rawValue], merge: true)
    }
    
    /// 현재 로그인 되어있는 회원이 모임에 참여합니다.
    ///  - Parameter roomID(String): 가입할 모임 ID
    public func joinRoom(_ roomID: String) async throws {
        // 로그인 여부 및 회원정보 등록 여부에 따른 에러 throw
        var userService: UserService = UserService()
        try await userService.loginedCheck()
        
        // 이미 위에서 uid 검증을 끝냈으므로, 강제 언래핑
        let uid = AuthenticationService.shared.currentUID!
        
        if try await isJoined(roomID: roomID, userUID: uid) {
            // 이미 방에 가입이 되어있을 경우 에러 throw
            throw FirebaseErrorType.alreadyJoinedRoom
        } else {
            let tempModel = JoinedUserModel(userID: uid, joinedDatetime: Date())
            try fbConstants.joinedCollection(roomID).document(uid).setData(from: tempModel, merge: true)
            // 유저 데이터에 가입한 모임 ID 추가
            try await fbConstants.userCollection.document(uid).updateData(["joinedRooms": FieldValue.arrayUnion([roomID])])
            
            
            try ChattingService(roomID: roomID).sendMessage(message: "\(uid)_입장")
            // MARK: - FCM 임시구현
            
            guard let roomInfo = try await roomInfo(roomID) else { return }
            print("roomInfo: \(roomInfo)")
            print("uid: \(uid)")
            guard let loginedUserInfo = try await userService.findUserInfo(uid: uid) else { return }
            
            // 누군가 참여 했음을 알려주는 푸시 기능
            // 1. 참여자 정보 불러오기
            let participants = try await joinedUsers(roomID: roomID)
            
            print("참여자 정보 : \(participants)")
            
            // 2. 참여자 토큰 알아오기
            for participant in participants {
                print("참여자 : \(participant.userID)\n")
                if participant.userID != uid {
                    // 본인 빼고
                    // 메시지 보내기
                    await PushService.shared.pushMessage(targetUID: participant.userID, title: "모임 참여 알림", body: "\(loginedUserInfo.userName)님께서 \(roomInfo.title)모임에 가입하셨습니다.", data: [.room: roomID])
                }
            }
        }
    }
    
    /// 모임을 탈퇴합니다.
    ///  - Parameter roomID(String): 가입할 모임 ID
    public func leaveRoom(roomID: String) async throws {
        // 로그인 여부 및 회원정보 등록 여부에 따른 에러 throw
        var userService: UserService? = UserService()
        try await userService?.loginedCheck()
        userService = nil
        
        // 이미 위에서 uid 검증을 끝냈으므로, 강제 언래핑
        let uid = AuthenticationService.shared.currentUID!
        
        if try await isJoined(roomID: roomID, userUID: uid) {
            try await fbConstants.joinedCollection(roomID).document(uid).delete()
            try await fbConstants.userCollection.document(uid).updateData(["joinedRooms": FieldValue.arrayRemove([roomID])])
        } else {
            // 방에 가입이 되어있지 않을 경우 에러 throw
            throw FirebaseErrorType.notJoinedRoom
        }
    }
    
    // TODO: 모임에 참여한 User 리스트 뽑아주기
    
    /// 모임에 참여한 유저의 목록을 불러옵니다.
    /// - Parameter roomID(String): 확인 할 모임 ID
    /// - Returns Array(UserModel)
    public func joinedUsers(roomID: String) async throws -> [JoinedUserModel] {
        let snapshop = try await fbConstants.joinedCollection(roomID).getDocuments()
        return try snapshop.documents.map { try $0.data(as: JoinedUserModel.self) }
    }
    
    /// 모임 참여 여부를 확인합니다.
    /// - Parameter roomID(String): 확인 할 모임 ID
    /// - Parameter uid(String): 유저의 uid
    /// - Returns: 참여 여부(Bool)
    public func isJoined(roomID: String, userUID uid: String) async throws -> Bool {
        let document = try await fbConstants.joinedCollection(roomID).document(uid).getDocument()
        return document.exists
    }
    
    /// 모임 정보를 불러옵니다.
    /// - Parameter roomID(String): 확인 할 모임 ID
    /// - Returns: RoomModel
    public func roomInfo(_ roomID: String) async throws -> RoomModel? {
        do {
            let document = try await fbConstants.roomCollection.document(roomID).getDocument()
            return try document.data(as: RoomModel.self)
        } catch {
            print("에러: \(error)")
            return nil
        }
    }
}
