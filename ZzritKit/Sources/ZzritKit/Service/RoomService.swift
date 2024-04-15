//
//  File.swift
//
//
//  Created by woong on 4/8/24.
//

import Foundation

import FirebaseFirestore

@available(iOS 16.0, *)
public final class RoomService {
    public static let shared = RoomService()
    let fbConstants = FirebaseConstants()
    
    private var lastSnashot: QueryDocumentSnapshot?
    // 쿼리를 아끼기 위해 존재. 검색했을때 나와줄 친구들.
    var tempRooms: [RoomModel] = []
    
    private var isPagingEnd: Bool = false
    
    // 임시 값, 온라인, 이미지URL은 반드시 존재합니다.
    public static let onlineRoomModel: RoomModel = ZzritKit.RoomModel(title: "9시 옵치고고", category: .game, dateTime: Date(), content: "9시에 옵치 궈궈할사람 구해요.9시에 옵치 궈궈할사람 구해요.9시에 옵치 궈궈할사람 구해요.9시에 옵치 궈궈할사람 구해요.9시에 옵치 궈궈할사람 구해요.9시에 옵치 궈궈할사람 구해요.", coverImage:  "https://picsum.photos/200", isOnline: true, platform: .discord, status: .activation, leaderID: "123123", limitPeople: 5)
    
    // 임시 값, 오프라인, deactive
    public static let offlineRoomModel: RoomModel = ZzritKit.RoomModel(title: "저녁 같이 먹을 사람", category: .etc, dateTime: Date(), placeLatitude: 37.4, placeLongitude: 126.4, placeName: "맘스터치", content: "저녁에 같이 밥먹을 사람을 구해요, 근데 이제 술을 곁들인", coverImage: "https://picsum.photos/200", isOnline: false, status: .activation, leaderID: "123123", limitPeople: 5)
    
    /**
     # Description
     - 모임 추가를 위한 메서드
     # Parameters
     - room: RoomModel
     # Error
     - FirebaseErrorType.failCreateRoom
     */
    public func createRoom(_ room: RoomModel) async throws {
        do {
            // TODO: 빈칸 있으면 에러.(소비자앱과 상의 필.)
            let result = try fbConstants.roomCollection.addDocument(from: room)
            try await joinRoom(result.documentID)
            //쿼리를 아끼기 위한 append
            tempRooms.append(room)
            // TODO: 모임 참여 await
        } catch {
            throw FirebaseErrorType.failCreateRoom
        }
    }
    
    public func loadRoom(isInitial: Bool = true) async throws -> [RoomModel] {
        do {
            
            if isPagingEnd {
                print("더이상 갖고올 데이터가 없음.")
                throw FirebaseErrorType.noMoreSearching
            }
            
            var query = fbConstants.roomCollection
                .whereField("status", isEqualTo: "activation")
                .limit(to: 16)
            
            // 필터가 있는 경우
            // 검색탭에서 필터링된 쿼리 만들기
            // 제목으로 필터링하는 부분 나중에 다시 사용할 수도있어서 일단은 주석처리했습니다.
//            if title != "" {
//                // title이 있다면
//                query = query.whereField("title", isEqualTo: title!)
//            }
            
            if !isInitial {
                query = query.start(afterDocument: lastSnashot!)
            }
            
            let snapshot = try await query.getDocuments()
            
            let documents = snapshot.documents
            lastSnashot = documents.last
            
            if lastSnashot == nil {
                isPagingEnd = true
            }
            
            //쿼리를 아끼기 위한 append
//            tempRooms.append(contentsOf: documents)
            // 유저앱에서 데이터를 들고있어야해서 이부분은 추후 수정 필수
            for temp in documents {
                tempRooms.append(try temp.data(as: RoomModel.self))
            }
            
            return tempRooms
        } catch {
            throw FirebaseErrorType.failLoadRoom
        }
    }
    
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
    
    /// 현재 로그인 되어있는 회원이 모임에 창여합니다.
    ///  - Parameter roomID(String): 가입할 모임 ID
    public func joinRoom(_ roomID: String) async throws {
        // 로그인 여부 및 회원정보 등록 여부에 따른 에러 throw
        var userService: UserService? = UserService()
        try await userService?.loginedCheck()
        userService = nil
        
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
    public func joinedUsers(roomID: String) async throws -> [UserModel] {
        let snapshop = try await fbConstants.joinedCollection(roomID).getDocuments()
        return try snapshop.documents.map { try $0.data(as: UserModel.self) }
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
    public func roomInfo(_ roomID: String) async throws -> RoomModel {
        let document = try await fbConstants.roomCollection.document(roomID).getDocument()
        return try document.data(as: RoomModel.self)
    }
}
