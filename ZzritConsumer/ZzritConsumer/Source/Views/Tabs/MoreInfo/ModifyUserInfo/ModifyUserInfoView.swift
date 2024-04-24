//
//  ModifyUserInfoView.swift
//  ZzritConsumer
//
//  Created by woong on 4/23/24.
//

import SwiftUI

import ZzritKit

struct ModifyUserInfoView: View {
    var storageService = StorageService()
    var imageManager = ImageManager()
    private let authService = AuthenticationService.shared
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedImage: UIImage?
    
    @State private var nickName = ""
    @State private var isDuplicate = false
    
    @State private var finishProfile = false
    
    @EnvironmentObject private var userService: UserService
    
    @Binding var registeredUID: String
    
    var body: some View {
        NavigationStack {
            HStack {
                SetProfilePhotoView(selectedImage: $selectedImage)
            }
            .padding(40)
            
            if #available(iOS 17.0, *) {
                UserInputCellView(text: $nickName, title: "별명", symbol: "rectangle.and.pencil.and.ellipsis")
                    .onChange(of: nickName) {
                        ProfileSettingDone()
                    }
            } else {
                UserInputCellView(text: $nickName, title: "별명", symbol: "rectangle.and.pencil.and.ellipsis")
                    .onChange(of: nickName, perform: { value in
                        ProfileSettingDone()
                    })
            }
            
            // MARK: isduplicate - nickname 보내고 중복 확인후 (중복이면 true로 반환) -> 수시로 하나요?
            if isDuplicate {
                ErrorTextView(title: "이미 존재하는 별명입니다.")
            } else {
                ErrorTextView(title: "")
            }
            
            Spacer()
            
            // TODO: 성별은 isMan과 isWoman중 true인 것으로 보내기. (enum 반환 함수 만들기)
            if #available(iOS 17.0, *) {
                GeneralButton("수정완료", isDisabled: !finishProfile) {
                    modifyUserInfo()
                    dismiss()
                }
                
            } else {
                GeneralButton("수정완료", isDisabled: !finishProfile) {
                    modifyUserInfo()
                    dismiss()
                }
                
            }
        }
        .onAppear {
            Task {
                let imagePath = userService.loginedUser?.userImage ?? "NONE"
                if let image = await ImageCacheManager.shared.findImageFromCache(imagePath: imagePath) {
                    selectedImage = image
                }
                nickName = userService.loginedUser?.userName ?? ""
            }
        }
        .padding(20)
        .toolbarRole(.editor)
    }
    
    // MARK: 일단 별명만 채워도 넘어가게 하도록 설정.
    func ProfileSettingDone() {
        if !isDuplicate {
            finishProfile = true
        } else {
            finishProfile = false
        }
    }
    
    // 프로필 저장
    private func modifyUserInfo() {
        
        guard let userUploadImage = selectedImage else { return }
        
        // 유저 프로필 리사이징
        guard let selectedImage = (userUploadImage.size.width) < 300 ? userUploadImage : userUploadImage.resizeWithWidth(width: 300) else { return }
        
        // 이미지 -> data 변환
        guard let imageData = selectedImage.pngData() else { return }
        
        // 이미지 경로 지정
        let dayString = DateService.shared.formattedString(date: Date(), format: "yyyyMMdd")
        let timeString = DateService.shared.formattedString(date: Date(), format: "HHmmss")
        let imageDir: [StorageService.StorageName: [String]] = [.profile: [registeredUID, dayString, timeString]]
        
        Task {
            do {
                // 이미지 firebase 올리고 저장 path 받아오기
                guard let imagePath = try await storageService.imageUpload(dirs: imageDir, image: imageData) else { return }
                
                userService.modifyUserInfo(userID: authService.currentUID!,
                                           userName: nickName,
                                           imageURL: imagePath)
                // 변경된 회원정보 firebase로
                _ = try await userService.loggedInUserInfo()
                
                // 이미지 캐시 저장
                ImageCacheManager.shared.updateImageFirst(name: imagePath, image: selectedImage)
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

//#Preview {
//    ModifyUserInfoView(emailField: "ㅁㄴㅇㄹ", registeredUID: .constant(""))
//}
