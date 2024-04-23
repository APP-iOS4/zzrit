//
//  RoomCreateViewModel.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/10/24.
//

import SwiftUI

import ZzritKit

final class RoomCreateViewModel {
    
    // MARK: - 저장 프로퍼티
    /// 모임 불러오는 싱글톤 인스턴스
    private var roomService = RoomService.shared
    
    /// 모임 리더 아이디
    private var leaderID: String?
    /// 선택된 모임 카테고리
    private var category: CategoryType?
    /// 모임 제목
    private var title: String?
    /// 모임 이미지
    private var selectedImage: UIImage?
    /// 모임 소개
    private var roomIntroduction: String?
    /// 모임 진행 방식
    private var isOnline: Bool?
    /// 모임 플랫폼
    private var platform: PlatformType?
    /// 모임 위치
    private var placeLatitude: Double?
    private var placeLongitude: Double?
    /// 날짜 · 시간
    private var dateTime: Date?
    /// 모임 제한 참여자 수
    private var limitPeople: Int?
    /// 모임 성별  제한
    private var genderLimitation: GenderType?
    /// 정전기 지수 제한
    private var scoreLimitation: Int?
    
    let storageService = StorageService()
    
    // FIXME: 현재 계정의 uid로 바꾸어 주기
//    var uid: String = "dPwldldl"
    
    // MARK: - init
    
    // FIXME: 여기 부분의 coverImage 고쳐야 함
    
    init(category: CategoryType? = nil, title: String? = nil, selectedImage: UIImage? = nil, roomIntroduction: String? = nil, isOnline: Bool? = nil, platform: PlatformType? = nil, placeLatitude: Double? = nil, placeLongitude: Double? = nil, dateTime: Date? = nil, limitPeople: Int? = nil, genderLimitation: GenderType? = nil, scoreLimitation: Int? = nil) {
        self.category = category
        self.title = title
        self.selectedImage = selectedImage
        self.roomIntroduction = roomIntroduction
        self.isOnline = isOnline
        self.platform = platform
        self.placeLatitude = placeLatitude
        self.placeLongitude = placeLongitude
        self.dateTime = dateTime
        self.limitPeople = limitPeople
        self.genderLimitation = genderLimitation
        self.scoreLimitation = scoreLimitation
    }
    
    // MARK: - Firebase에 모임 추가
    func createRoom(userModel: UserModel?) async -> String? {
        saveLeaderID(userModel: userModel)
        
        let newRoom = await makeNewRoom()
        
        if let newRoom {
            do {
                let newRoomID = try await roomService.createRoom(newRoom)
                return newRoomID
            } catch {
                Configs.printDebugMessage("모임 생성 중 에러가 발생했습니다!")
            }
        } else {
            Configs.printDebugMessage("모임이 생성되지 않았습니다!")
            return nil
        }
        return nil
    }
    
    // MARK: - RoomModel을 만들어주는 함수
    
    /// 선택 사항들을 확인해서 새 모임 인스턴스를 만들어주는 함수
    private func makeNewRoom() async -> RoomModel? {
        // 유저 UID 확인
        guard let leaderID else {
            Configs.printDebugMessage("유저 UID가 저장되지 않음.")
            return nil
        }
        // 카테고리 확인
        guard let category else {
            Configs.printDebugMessage("모임 카테고리가 선택되지 않았거나 저장되지 않음.")
            return nil
        }
        // 모임 제목 확인
        guard let title else {
            Configs.printDebugMessage("모임 제목이 입력되지 않았거나 저장되지 않음.")
            return nil
        }
        guard !title.isEmpty else {
            Configs.printDebugMessage("모임 제목이 입력되지 않았거나 저장되지 않음.")
            return nil
        }
        // 모임 소개 확인
        guard let roomIntroduction else {
            Configs.printDebugMessage("모임 소개가 입력되지 않았거나 저장되지 않음.")
            return nil
        }
        guard !roomIntroduction.isEmpty else {
            Configs.printDebugMessage("모임 소개가 입력되지 않았거나 저장되지 않음.")
            return nil
        }
        // 모임 이미지 확인 및 파이어베이스에 저장
        let coverImage = await saveCoverImage(coverUIImage: selectedImage)
        // 모임 시간 확인
        guard let dateTime else {
            Configs.printDebugMessage("모임 시간이 입력되지 않았거나 저장되지 않음.")
            return nil
        }
        guard Date() <= dateTime else {
            Configs.printDebugMessage("모임 시간이 짧다")
            return nil
        }
        // 모임 참여자수 제한 확인
        guard let limitPeople else {
            Configs.printDebugMessage("모임 참여자수 제한이 입력되지 않았거나 저장되지 않음.")
            return nil
        }
        // 모임 성별 제한 확인 - 안해도 됨
        // 모임 정전기 지수 제한 확인 - 안해도 됨
        
        // 모임 진행 방식 확인
        guard let isOnline else {
            Configs.printDebugMessage("모임 진행 방식이 입력되지 않았거나 저장되지 않음.")
            return nil
        }
        if isOnline == true {
            guard let platform else {
                Configs.printDebugMessage("모임 진행 방식은 입력되었지만, 플랫폼은 저장되지 않음.")
                return nil
            }
            return RoomModel(
                title: title,
                category: category,
                dateTime: dateTime,
                content: roomIntroduction,
                coverImage: coverImage,
                isOnline: isOnline,
                platform: platform,
                status: .activation,
                leaderID: leaderID,
                limitPeople: limitPeople
            )
        } else {
            guard let placeLatitude, let placeLongitude else {
                Configs.printDebugMessage("모임 진행 방식은 입력되었지만, 위치는 저장되지 않음.")
                return nil
            }
            return RoomModel(
                title: title,
                category: category,
                dateTime: dateTime,
                placeLatitude: placeLatitude,
                placeLongitude: placeLongitude,
                content: roomIntroduction,
                coverImage: coverImage,
                isOnline: isOnline,
                status: .activation,
                leaderID: leaderID,
                limitPeople: limitPeople
            )
        }
    }
    
    // MARK: - 뷰에서 받아오는 함수
    
    /// 선택한 카테고리 저장하는 함수
    func saveSelectedCategory(selection: CategoryType?) {
        if let selection {
            self.category = selection
            Configs.printDebugMessage("선택한 카테고리가 저장됨.")
        } else {
            Configs.printDebugMessage("선택한 카테고리가 없어 에러가 발생함!")
        }
    }
    
    /// 새 모임 제목을 저장하는 함수
    func saveTitle(title: String) {
        // 저장할 새 모임 제목이 비어있는지 체크해서 비어있다면 리턴, 아니라면 진행
        guard !title.isEmpty else {
            Configs.printDebugMessage("새 모임 제목이 없어 에러가 발생함!")
            return
        }
        self.title = title
        Configs.printDebugMessage("새 모임 제목이 저장됨.")
    }
    
    /// 새 모임의 커버 UIImage를 이 인스턴스에 저장하는 함수
    func saveUIImage(selectedUIImage: UIImage?) {
        self.selectedImage = selectedUIImage
    }
    
    /// 새 모임의 커버 이미지를 저장하는 함수
    func saveCoverImage(coverUIImage: UIImage?) async -> String {
        guard let coverUIImage = coverUIImage else {
            Configs.printDebugMessage("coverUIImage 정보가 없음")
            return ""
        }
        guard let imageData = coverUIImage.pngData() else {
            Configs.printDebugMessage("coverImage의 png 정보가 없음")
            return ""
        }
        do {
            let coverImage: String = try await storageService.imageUpload(topDir: .roomCover, dirs: ["\(UUID().uuidString)"], image: imageData)
            Configs.printDebugMessage("파이어베이스에 새 모임 커버 이미지 저장 성공!")
            return coverImage
        } catch {
            Configs.printDebugMessage("에러: \(error)")
        }
        return ""
    }
    
    /// 새 모임의 소개글을 저장하는 함수
    func saveIntroduction(roomIntroduction: String) {
        // 저장할 새 모임 제목이 비어있는지 체크해서 비어있다면 리턴, 아니라면 진행
        guard !roomIntroduction.isEmpty else {
            Configs.printDebugMessage("새 모임의 소개글이 없어 에러가 발생함!")
            return
        }
        self.roomIntroduction = roomIntroduction
        Configs.printDebugMessage("새 모임의 소개글이 저장됨.")
    }
    
    /// 새 모임 진행방식을 저장하는 함수
    func saveRoomProcess(processSelection: RoomProcessType?, placeLatitude: Double?, placeLongitude: Double?, platform: PlatformType?) {
        // 저장할 새 모임의 진행방식을 체크해서 비어있다면 리턴, 아니라면 진행
        guard let processSelection else {
            Configs.printDebugMessage("선택한 모임 진행방식이 없어 에러가 발생함!")
            return
        }
        switch processSelection {
        case .offline:
            if let placeLatitude, let placeLongitude {
                self.isOnline = processSelection.value
                self.placeLatitude = placeLatitude
                self.placeLongitude = placeLongitude
                Configs.printDebugMessage("선택한 모임 진행 방식은 오프라인이며, 위치 정보가 저장되었습니다.")
            } else {
                Configs.printDebugMessage("오프라인 방식이 선택되었지만, 위치 정보가 없어 에러가 발생함!")
            }
        case .online:
            if let platform {
                self.isOnline = processSelection.value
                self.platform = platform
                Configs.printDebugMessage("선택한 모임 진행 방식은 온라인이며, 플랫폼 정보가 저장되었습니다.")
            } else {
                Configs.printDebugMessage("온라인 방식이 선택되었지만, 플랫폼 정보가 없어 에러가 발생함!")
            }
        }
    }
    
    /// 새 모임 시간 저장
    func saveDateTime(dateSelection: DateType?, timeSelection: Date) {
        guard let dateTime = dateSelection?.date else {
            Configs.printDebugMessage("선택한 날짜가 없어 에러가 발생함!")
            return
        }
        
        let dateComponents = DateComponents(
            year: Calendar.current.component(.year, from: dateTime),
            month: Calendar.current.component(.month, from: dateTime),
            day: Calendar.current.component(.day, from: dateTime),
            hour: Calendar.current.component(.hour, from: timeSelection),
            minute: Calendar.current.component(.minute, from: timeSelection)
        )
        
        self.dateTime = Calendar.current.date(from: dateComponents)
        Configs.printDebugMessage("선택한 모임 진행 방식은 온라인이며, 플랫폼 정보가 저장되었습니다.")
    }
    
    /// 새 모임의 제한 참여자 수 저장
    func saveLimitPeople(limitPeople: Int) {
        guard 2 <= limitPeople && limitPeople <= 10 else {
            Configs.printDebugMessage("선택한 모임 제한 참여자 수에 에러가 발생함!")
            return
        }
        self.limitPeople = limitPeople
        Configs.printDebugMessage("모임 참여자 제한 수 저장.")
    }
    
    /// 새 모임의 성별 제한 저장
    func saveGenderLimitation(genderLimitation: GenderType?) {
        self.genderLimitation = genderLimitation
        Configs.printDebugMessage("모임 성별 제한 저장.")
    }
    
    /// 새 모임의 정전기 지수 제한 저장
    func saveScoreLimitation(hasScoreLimit: Bool, scoreLimitation: Double) {
        guard hasScoreLimit else {
            return
        }
        guard 0 <= scoreLimitation && scoreLimitation <= 100 else {
            Configs.printDebugMessage("선택한 모임 제한 참여자 수에 에러가 발생함!")
            return
        }
        self.scoreLimitation = Int(scoreLimitation)
    }
    
    /// 새 모임 리더 아이디 저장
    func saveLeaderID(userModel: UserModel?) {
        guard let userModel else {
            Configs.printDebugMessage("현재 로그인된 유저 정보가 없어 에러가 발생함!")
            return
        }
        self.leaderID = userModel.id
        Configs.printDebugMessage("로그인된 유저 UID 저장.")
    }
}
