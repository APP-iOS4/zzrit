//
//  UserService.swift
//
//
//  Created by Sanghyeon Park on 4/8/24.
//

import Foundation

import FirebaseFirestore

@available(iOS 16.0.0, *)
public final class UserService: ObservableObject {
    private let firebaseConst = FirebaseConstants()
    private let authService = AuthenticationService.shared
    @Published public var loginedUser: UserModel?
    
    public init() { }
    
    // MARK: Public Methods
    
    /// 현재 로그인 되어있는 사용자의 정보를 가져옵니다.
    /// - Returns: Optional(UserModel)
    @MainActor
    public func loggedInUserInfo() async throws -> UserModel? {
        if let uid = authService.currentUID {
            loginedUser = try await findUserInfo(uid: uid)
            return loginedUser
        } else {
            return nil
        }
    }
    
    /// 사용자의 정보를 가져옵니다.
    /// - Parameter uid(String): FirebaseAuth 로그인정보의 uid
    /// - Returns: Optional(UserModel)
    public func findUserInfo(uid: String) async throws -> UserModel? {
        // 유저 정보가 존재하지 않을 경우, 에러 throw
        let document = try await firebaseConst.userCollection.document(uid).getDocument()
        if !document.exists {
            throw AuthError.noUserInfo
        }
        
        return try await firebaseConst.userCollection.document(uid).getDocument(as: UserModel.self)
    }
    
    /// 사용자의 정보를 저장합니다.
    /// - Parameter uid(String): FirebaseAuth 로그인정보의 uid
    /// - Parameter info(UserModel): 사용자의 정보가 담겨있는 모델
    public func setUserInfo(uid: String, info: UserModel) throws {
        try firebaseConst.userCollection.document(uid).setData(from: info, merge: true)
    }
    
    /// 회원탈퇴
    public func secession(reason: String) async throws {

        try await loginedCheck()
        
        do {
            let tempLoginedUserInfo = try await loggedInUserInfo()!
            
            // 회원탈퇴가 이미 진행중일 경우 에러 throw
            if let _ = tempLoginedUserInfo.secessionDate {
                throw AuthError.secessioning
            }
            
            let loginedUID = tempLoginedUserInfo.id!
            print("UID: \(loginedUID)")

            try await firebaseConst.userCollection.document(loginedUID).updateData([
                "secessionDate": Date(),
                "secessionReason": reason
            ])
            
            // 정상적으로 회원탈퇴가 처리 되면 참여중인 방에서 탈퇴합니다.
            if let joinedRoomIDs = tempLoginedUserInfo.joinedRooms {
                // 모임 정보를 가져온다.
                for roomID in joinedRoomIDs {
                    if let room = try await RoomService.shared.roomInfo(roomID) {
                        // 활성화 상태의 모임에만 탈퇴 처리를 진행한다.
                        if room.status == .activation {
                            // 채팅 메시지 전송
                            var chattingService: ChattingService? = ChattingService(roomID: roomID)
                            let userName = loginedUser?.userName ?? "알 수 없는 회원"
                            
                            // 모임 탈퇴
                            try await RoomService.shared.leaveRoom(roomID: roomID)
                            
                            // 모임장인 경우 모임을 비활성화
                            if room.leaderID == loginedUID {
                                RoomService.shared.changeStatus(roomID: roomID, status: .deactivation)
                                try chattingService?.sendMessage(message: "\(loginedUID)_퇴장")
                            } else {
                                try chattingService?.sendMessage(message: "\(loginedUID)_퇴장")
                            }
                            
                            chattingService = nil
                        }
                    }
                }
            }
        } catch {
            throw error
        }
    }
    
    /// 회원탈퇴 철회
    public func secessionCancel() async throws {
        do {
            guard let secessioningUID = authService.secessioningUID else { return }
            try await firebaseConst.userCollection.document(secessioningUID).updateData([
                "secessionDate": FieldValue.delete(),
                "secessionReason": FieldValue.delete()
            ])
        } catch {
            throw error
        }
    }
    
    /// 모임 후 찌릿 멤버를 선정하여 정전기 지수를 높입니다.
    /// - Parameter userUIDs([String]): 정전기 지수를 높일 회원의 uid 배열
    public func applyEvaluation(userUIDs: [String]) async throws {
        try await loginedCheck()
        
        do {
            for uid in userUIDs {
                try await firebaseConst.userCollection.document(uid).updateData(["staticGauge": FieldValue.increment(1.0)])
            }
        } catch {
            throw error
        }
    }
    
    /// 최신 약관을 불러옵니다.
    /// - Parameter type(TermType): 약관의 타입
    /// - Returns TermModel
    /// - Important: 유저가 동의한 약관의 날짜와 최신 날짜의 정보와 같은지 확인하는 작업은 앱단에서 구현 부탁드립니다.
    /// - Important: 시행날짜가 미래인 경우는 가져오지 않습니다.
    public func term(type: TermType) async throws -> TermModel {
        let snapshot = try await firebaseConst.termCollection
            .whereField("type", isEqualTo: type.rawValue)
            .whereField("date", isLessThanOrEqualTo: Date.now)
            .order(by: "date", descending: true)
            .limit(to: 1)
            .getDocuments()
        
        if snapshot.documents.isEmpty {
            throw FirebaseErrorType.noDocument
        }
        
        return try snapshot.documents.first!.data(as: TermModel.self)
    }
    
    /// 해당 회원의 이달의 모임 개설의 개수를 불러옵니다.
    public func createdRoomsCount(_ uid: String) async -> Int {
        let today = Date()
        
        // 현재 달력 가져오기
        let calendar = Calendar.current
        var startComponents = calendar.dateComponents([.year, .month], from: today)
        startComponents.day = 1
        startComponents.hour = 0
        startComponents.minute = 0
        startComponents.second = 0
        guard let startDate = calendar.date(from: startComponents) else { return 0 }
        
        var endComponents = DateComponents(month: 1, day: -1)
        endComponents.hour = 23
        endComponents.minute = 59
        endComponents.second = 50
        guard let endDate = calendar.date(byAdding: endComponents, to: startDate) else { return 0 }
        
        do {
            let documents = try await firebaseConst.roomCollection
                .whereField("leaderID", isEqualTo: uid)
                .whereField("createTime", isGreaterThanOrEqualTo: startDate)
                .whereField("createTime", isLessThanOrEqualTo: endDate)
                .getDocuments()
            
            return documents.count
        } catch {
            print("이달의 모임 개설 개수 불러오는 도중 에러: \(error)")
            return 0
        }
    }
    
    // MARK: - Private Methods
    
    /// 접속된 회원정보 삭제
    func deleteLoginedUserInfo() async throws {
        try await loginedCheck()
        
        let loginedUID = try await loggedInUserInfo()!.id!
        try await firebaseConst.userCollection.document(loginedUID).delete()
    }
    
    /// 로그인 상태 검증
    func loginedCheck() async throws {
        guard let _ = authService.currentUID else {
            throw AuthError.notLogin
        }
        
        guard let _ = try await loggedInUserInfo() else {
            throw AuthError.noUserInfo
        }
    }
    
    // MARK: - Admin Methods
    
    /// 현재 로그인 되어있는 관리자의 정보를 가져옵니다.
    /// - Returns: Optional(AdminModel)
    public func loginedAdminInfo() async throws -> AdminModel? {
        if let uid = authService.currentUID {
            return try await getAdminInfo(uid: uid)
        } else {
            return nil
        }
    }
    
    /// 관리자의 정보를 가져옵니다.
    /// - Parameter uid(String): FirebaseAuth 로그인정보의 uid
    /// - Returns: Optional(AdminModel)
    public func getAdminInfo(uid: String) async throws -> AdminModel? {
        // 유저 정보가 존재하지 않을 경우, 에러 throw
        let document = try await firebaseConst.adminCollection.document(uid).getDocument()
        if !document.exists {
            throw AuthError.noUserInfo
        }
        
        return try await firebaseConst.adminCollection.document(uid).getDocument(as: AdminModel.self)
    }
    
    /// 사용자의 정보를 저장합니다.
    /// - Parameter admin(String): FirebaseAuth 로그인정보의 uid
    /// - Parameter info(UserModel): 사용자의 정보가 담겨있는 모델
    public func setUserInfo(admin uid: String, info: AdminModel) throws {
        try firebaseConst.adminCollection.document(uid).setData(from: info, merge: true)
    }
    
    /// 약관 정보를 등록합니다.
    /// - Parameter term(TermModel): 약관 정보 모델
    public func addTerm(term: TermModel) throws {
        try firebaseConst.termCollection.addDocument(from: term)
    }
    
    /// 약관 정보를 불러옵니다.
    /// - Parameter type(TermType): 약관의 타입
    public func terms(type: TermType) async throws -> [TermModel] {
        let snapshot = try await firebaseConst.termCollection
            .whereField("type", isEqualTo: type.rawValue)
            .order(by: "date", descending: true)
            .getDocuments()
        
        if snapshot.isEmpty {
            throw FirebaseErrorType.noDocument
        }
        
        return try snapshot.documents.map { try $0.data(as: TermModel.self) }
    }
    
    public func modifyUserInfo(userID uid: String, userName: String, imageURL: String) {
        firebaseConst.userCollection.document(uid).updateData(["userName": userName,
                                                               "userImage": imageURL])
    }
    
    /// 디바이스 토큰을 서버에 저장합니다.
    public func updatePushToken(token: String) async {
        do {
            if let userInfo = try await loggedInUserInfo() {
                try await firebaseConst.userCollection.document(userInfo.id!).setData(["pushToken": token], merge: true)
            }
        } catch {
            print("디바이스 토큰 등록 에러: \(error)")
        }
    }
}
