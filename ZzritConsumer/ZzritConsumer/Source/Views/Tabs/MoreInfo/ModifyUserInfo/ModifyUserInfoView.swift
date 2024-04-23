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
    private let authService = AuthenticationService.shared
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedImage: UIImage?
    
    @State private var nickName = ""
    @State private var isDuplicate = false
    
    @State private var isMan = true
    @State private var isWoman = false
    
    @State private var birthYear =  Calendar.current.component(.year, from: Date()) - 19
    @State private var birthYearPickerShow = false
    
    @State private var finishProfile = false
    @State private var completeSignUp = false
    
    @EnvironmentObject private var userService: UserService
    
    var emailField: String = ""
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
    
    private func modifyUserInfo() {
        // 유저 프로필은 width: 300 크기로 리사이징해서 올라감
        guard let selectedImage = (selectedImage?.size.width)! < 300 ? selectedImage : selectedImage?.resizeWithWidth(width: 300) else { return }
        guard let imageData = selectedImage.pngData() else { return }
        Task {
            do {
                // 이미지 올리고 url 받아오기
                let downloadURL = try await storageService.imageUpload(topDir: .profile, dirs: ["\(registeredUID)", Date().toString()], image: imageData)
                
                userService.modifyUserInfo(userID: authService.currentUID!,
                                           userName: nickName,
                                           imageURL: downloadURL)
                _ = try await userService.loggedInUserInfo()
                // 이미지 캐시 저장
                ImageCacheManager.shared.updateToCache(name: downloadURL, image: selectedImage)
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    ModifyUserInfoView(emailField: "ㅁㄴㅇㄹ", registeredUID: .constant(""))
}
