//
//  SetProfileView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/8/24.
//

import SwiftUI

import ZzritKit

struct SetProfileView: View {
    // 채팅의 이미지 저장을 위한 것
    var storageService = StorageService()
    
    @Binding var isTopDismiss: Bool
    
    @State private var selectedImage: UIImage?
    
    @State private var nickName = ""
    @State private var isDuplicate = false
    
    @State private var isMan = true
    @State private var isWoman = false
    
    @State private var birthYear =  Calendar.current.component(.year, from: Date()) - 19
    @State private var birthYearPickerShow = false
    
    @State private var finishProfile = false
    @State private var completeSignUp = false
    
    @State private var isLoading = false
    
    @EnvironmentObject private var userService: UserService
    
    var emailField: String = ""
    @Binding var registeredUID: String
    
    var body: some View {
        NavigationStack {
            ScrollView {
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
                
                HStack {
                    Label("성별", systemImage: "person.fill")
                        .foregroundStyle(Color.staticGray4)
                    Spacer()
                    ArchieveSelectionButtonView(isSelected: isMan, "남성", tapAction: {
                        isMan = true
                        isWoman = false
                    })
                    .frame(width: 100)
                    ArchieveSelectionButtonView(isSelected: isWoman, "여성", tapAction: {
                        isWoman = true
                        isMan = false
                    })
                    .frame(width: 100)
                }
                .padding()
                
                HStack {
                    Label("출생년도", systemImage: "birthday.cake")
                        .foregroundStyle(Color.staticGray4)
                    Spacer()
                    Button(action: {
                        birthYearPickerShow.toggle()
                    }, label: {
                        Text("\(String(birthYear)) 년생")
                            .foregroundStyle(Color.pointColor)
                    })
                    .sheet(isPresented: $birthYearPickerShow) {
                        BirthYearPickerView(selectedYear: $birthYear)
                    }
                }
                .padding()
                Spacer()
                
                GeneralButton("다음", isDisabled: !finishProfile) {
                    setUserInfo()
                }
                .navigationDestination(isPresented: $completeSignUp) {
                    CompleteSignUpView(isTopDismiss: $isTopDismiss)
                }
                
            }
            .padding(20)
            .toolbarRole(.editor)
            .loading(isLoading, message: "회원 정보를 등록하고 있습니다.")
        }
    }
    
    // MARK: 일단 별명만 채워도 넘어가게 하도록 설정.
    func ProfileSettingDone() {
        if nickName.isEmpty {
            finishProfile = false
        } else {
            finishProfile = true
        }
    }
    
    private func setUserInfo() {
        // 이미지가 있을때
        // 유저 프로필은 width: 300 크기로 리사이징해서 올라감
        
        isLoading.toggle()
        Task {
            do {
                // 닉네임 확인
                isDuplicate = await userService.checkNicknameDuplicated(nickName: nickName)
                // 닉네임이 중복되지 않았다면
                if !isDuplicate {
                    let serviceTerm = try await userService.term(type: .service)
                    let privacyTerm = try await userService.term(type: .privacy)
                    let locationTerm = try await userService.term(type: .location)
                    
                    var getPath: String = "NONE"
                    
                    if let selectedImage, let imageData = selectedImage.pngData() {
                        guard let selectedImage = ((selectedImage.size.width) < 300 ? selectedImage : selectedImage.resizeWithWidth(width: 300) ) else { return }
                        
                        // 이미지 경로 설정
                        let dayString = DateService.shared.formattedString(date: Date(), format: "yyyyMMdd")
                        let timeString = DateService.shared.formattedString(date: Date(), format: "HHmmss")
                        let imageDir: [StorageService.StorageName: [String]] = [.profile : [registeredUID, dayString, timeString ]]
                        
                        // 이미지 올리고 url 받아오기
                        getPath = try await storageService.imageUpload(dirs: imageDir, image: imageData) ?? "NONE"
                        
                        Configs.printDebugMessage("이미지 파베에 올림")
                        
                        // 이미지 캐시 저장
                        ImageCacheManager.shared.updateImageFirst(name: getPath, image: selectedImage)
                    }
                    
                    // 유저 정보 모델에 저장
                    let userInfo: UserModel = .init(userID: emailField, userName: nickName, userImage: getPath, gender: isMan ? .male : .female, birthYear: birthYear, staticGauge: 20.0, agreeServiceDate: serviceTerm.date, agreePrivacyDate: privacyTerm.date, agreeLocationDate: locationTerm.date)
                    
                    // 유저 프로필 서버에 올리기
                    try userService.setUserInfo(uid: registeredUID, info: userInfo)
                }
                
                isLoading.toggle()
                if !isDuplicate {
                    completeSignUp.toggle()
                }
            } catch {
                Configs.printDebugMessage("에러: \(error)")
                isLoading = false
            }
        }
        
    }
}

#Preview {
    SetProfileView(isTopDismiss: .constant(false), emailField: "", registeredUID: .constant(""))
}
