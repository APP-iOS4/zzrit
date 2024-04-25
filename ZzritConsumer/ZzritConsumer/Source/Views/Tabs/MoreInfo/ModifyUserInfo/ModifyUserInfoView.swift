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
    @State private var originImage: UIImage?
    
    @State private var nickName = ""
    @State private var isDuplicate = false
    @State private var isSelecedImage = false
    
    @State private var isFinishProfile = false
    @State private var isLoading = false
    
    @EnvironmentObject private var userService: UserService
    
    @Binding var registeredUID: String
    
    var body: some View {
        NavigationStack {
            HStack {
                SetProfilePhotoView(selectedImage: $selectedImage)
            }
            .padding(40)
            
            UserInputCellView(text: $nickName, title: "별명", symbol: "rectangle.and.pencil.and.ellipsis")
                .customOnChange(of: nickName, handler: { _ in
                    ProfileSettingDone()
                })
            
            // MARK: isduplicate - nickname 보내고 중복 확인후 (중복이면 true로 반환) -> 수시로 하나요?
            if isDuplicate {
                ErrorTextView(title: "이미 존재하는 별명입니다.")
            } else {
                ErrorTextView(title: "")
            }
            
            Spacer()
            
            GeneralButton("수정완료", isDisabled: !isFinishProfile) {
                self.endTextEditing()
                modifyUserInfo()
            }
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .onAppear {
            Task {
                let imagePath = userService.loginedUser?.userImage ?? "NONE"
                if let image = await ImageCacheManager.shared.findImageFromCache(imagePath: imagePath) {
                    selectedImage = image
                    originImage = image
                }
                nickName = userService.loginedUser?.userName ?? ""
            }
        }
        .padding(20)
        .toolbarRole(.editor)
        // 이것 할때 네비게이션바 안보이면안대나
        .loading(isLoading, message: "회원 정보를 수정하고 있습니다.")
    }
    
    // MARK: 일단 별명만 채워도 넘어가게 하도록 설정.
    func ProfileSettingDone() {
        if !isDuplicate {
            isFinishProfile = true
        } else {
            isFinishProfile = false
        }
    }
    
    // 프로필 저장
    private func modifyUserInfo() {
        isLoading.toggle()
        
        // 바뀐 항목 체크
        var isNameChange = userService.loginedUser?.userName != nickName
        var isImageChange = selectedImage != originImage
        Configs.printDebugMessage("이름 : \(isNameChange) -- 이미지 : \(isImageChange)")
        var setImagePath = userService.loginedUser?.userImage
        
        
        if isImageChange, let selectedImage, let imageData = selectedImage.pngData()  {
            Task {
                do {
                    // 이미지 경로 지정
                    let dayString = DateService.shared.formattedString(date: Date(), format: "yyyyMMdd")
                    let timeString = DateService.shared.formattedString(date: Date(), format: "HHmmss")
                    let imageDir: [StorageService.StorageName: [String]] = [.profile: [registeredUID, dayString, timeString]]
                    
                    // 이미지 firebase 올리고 저장 path 받아오기
                    var imagePath = try await storageService.imageUpload(dirs: imageDir, image: imageData) ?? "NONE"
                    
                    userService.modifyUserInfo(userID: authService.currentUID!,
                                               userName: nickName,
                                               imageURL: imagePath)
                    
                    // 변경된 회원정보 firebase로
                    _ = try await userService.loggedInUserInfo()
                    
                    // 이미지 캐시 저장
                    ImageCacheManager.shared.updateImageFirst(name: imagePath, image: selectedImage)
                    isLoading.toggle()
                    dismiss()
                } catch {
                    Configs.printDebugMessage("에러: \(error)")
                    isLoading = false
                    
                }
            }
        } else {
            if isNameChange {
                Task {
                    do {
                        // 바뀐 닉네임만 적용되어 올라감.
                        userService.modifyUserInfo(userID: authService.currentUID!, userName: nickName, imageURL: setImagePath!)
                        
                        // 변경된 회원정보 firebase로
                        _ = try await userService.loggedInUserInfo()
                        isLoading.toggle()
                        dismiss()
                    } catch {
                        Configs.printDebugMessage("에러: \(error)")
                        isLoading = false
                    }
                }
            } else {
                Configs.printDebugMessage("변경 사항 없음.")
                isLoading.toggle()
                dismiss()
            }
        }
    }
}
