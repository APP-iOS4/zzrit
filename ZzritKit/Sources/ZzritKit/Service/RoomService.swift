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
    
    // 쿼리를 아끼기 위해 존재. 검색했을때 나와줄 친구들.
    var tempRooms: [RoomModel] = []
    
    // 임시 값, 온라인, 이미지URL은 반드시 존재합니다.
    public static let onlineRoomModel: RoomModel = ZzritKit.RoomModel(title: "9시 옵치고고", category: .game, dateTime: Date(), content: "9시에 옵치 궈궈할사람 구해요.9시에 옵치 궈궈할사람 구해요.9시에 옵치 궈궈할사람 구해요.9시에 옵치 궈궈할사람 구해요.9시에 옵치 궈궈할사람 구해요.9시에 옵치 궈궈할사람 구해요.", coverImage:  "https://picsum.photos/200", isOnline: true, platform: .discord, status: .activation, leaderID: "123123", limitPeople: 5)
    
    // 임시 값, 오프라인, deactive
    public static let offlineRoomModel: RoomModel = ZzritKit.RoomModel(title: "저녁 같이 먹을 사람", category: .etc, dateTime: Date(), placeLatitude: 37.4, placeLongitude: 126.4, content: "저녁에 같이 밥먹을 사람을 구해요, 근데 이제 술을 곁들인", coverImage: "https://picsum.photos/200", isOnline: false, status: .activation, leaderID: "123123", limitPeople: 5)
    
    // TODO: 모임 추가
    
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
            try fbConstants.roomCollection.addDocument(from: room)
            //쿼리를 아끼기 위한 append
            tempRooms.append(room)
            // TODO: 모임 참여 await
        } catch {
            throw FirebaseErrorType.failCreateRoom
        }
    }
    
    // TODO: 모임 불러오기
    func loadRoom(
        title: String? = nil,
        isOnline: Bool? = nil,
        placeLatitude: Double? = nil,
        placeLongitude: Double? = nil,
        dateTime: Date? = nil,
        category: CategoryType? = nil,
        isInitial: Bool
    ) async throws -> [RoomModel] {
        do {
            var query = fbConstants.roomCollection
            
            // 필터가 있는 경우
            //검색탭에서 필터링된 쿼리 만들기
            if (title != nil) || (isOnline != nil) || (placeLatitude != nil) || (placeLongitude != nil) || (dateTime != nil) || (category != nil) {
                let params: [String: Any?] = [
                    "title": title,
                    "isOnline": isOnline,
                    "placeLatitude": placeLatitude,
                    "placeLongitude": placeLongitude,
                    "dateTime": dateTime,
                    "category": category
                ]
                let filteredParams = params.filter { $0.value != nil}
                for (key, value) in filteredParams {
                    //value는 값이 있어야지만 남습니다. 따라서 forceUnwrapping 했습니다.
                    query = query.whereField(key, isEqualTo: value!) as! CollectionReference
                }
            }
            
            let snapshot = try await query.getDocuments()
            
            let documents = try snapshot.documents.map { try $0.data(as: RoomModel.self) }
            
            //쿼리를 아끼기 위한 append
            tempRooms.append(contentsOf: documents)
            return documents
        } catch {
            throw error
        }
    }
    // TODO: 모임 수정
    func modifyRoom(_ room: RoomModel) async throws {
        
    }
    
    // TODO: 모임 삭제
    
    // TODO: 모임 참여 - 해당 모임 하위 컬렉션 JoinedUser에 현재 user.id 넣어줘야됨.
    
    // TODO: 모임에 참여한 User 리스트 뽑아주기
    
    
    
}
