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
    
    @State private var selectedImage: UIImage?
    
    @State private var nickName = ""
    @State private var isDuplicate = false
    
    @State private var isMan = true
    @State private var isWoman = false
    
    @State private var birthYear =  Calendar.current.component(.year, from: Date()) - 19
    @State private var birthYearPickerShow = false
    
    @State private var finishProfile = false
    @State private var completeSignUp = false
    
    private let userService = UserService()
    
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
                .sheet(isPresented: $birthYearPickerShow, content: {
                    BirthYearPickerView(selectedYear: $birthYear)
                })
            }
            .padding()
            Spacer()
            
            // TODO: 성별은 isMan과 isWoman중 true인 것으로 보내기. (enum 반환 함수 만들기)
            if #available(iOS 17.0, *) {
                GeneralButton("다음", isDisabled: !finishProfile) {
                    setUserInfo()
                    completeSignUp.toggle()
                }
                .navigationDestination(isPresented: $completeSignUp, destination: {
                    CompleteSignUpView()
                })
                .onChange(of: finishProfile) {
                    
                }
            } else {
                GeneralButton("다음", isDisabled: !finishProfile) {
                    setUserInfo()
                    completeSignUp.toggle()
                }
                .navigationDestination(isPresented: $completeSignUp, destination: {
                    CompleteSignUpView()
                })
                .onChange(of: finishProfile, perform: { value in
                    
                })
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
    
    private func setUserInfo() {
        // 이미지가 있을때
        // 유저 프로필은 width: 300 크기로 리사이징해서 올라감
        if selectedImage != nil {
            guard let selectedImage = ((selectedImage?.size.width)! < 300 ? selectedImage : selectedImage?.resizeWithWidth(width: 300) ) else { return }
            Configs.printDebugMessage("이미지 리사이징 완료")
            if let imageData = selectedImage.pngData() {
                Configs.printDebugMessage("이미지 확장자 변환 완료")
                Task {
                    do {
                        let serviceTerm = try await userService.term(type: .service)
                        let privacyTerm = try await userService.term(type: .privacy)
                        let locationTerm = try await userService.term(type: .location)
                        
                        // 이미지 올리고 url 받아오기
                        let downloadURL = try await storageService.imageUpload(topDir: .profile, dirs: ["\(registeredUID)", Date().toString()], image: imageData)
                        
                        Configs.printDebugMessage("이미지 파베에 올림")
                        // 유저 정보 모델에 저장
                        let userInfo: UserModel = .init(userID: emailField, userName: nickName, userImage: downloadURL, gender: isMan ? .male : .female, birthYear: birthYear, staticGauge: 20.0, agreeServiceDate: serviceTerm.date, agreePrivacyDate: privacyTerm.date, agreeLocationDate: locationTerm.date)
                        
                        // 유저 프로필 서버에 올리기
                        try userService.setUserInfo(uid: registeredUID, info: userInfo)
                        
                        // 이미지 캐시 저장
                        ImageCacheManager.shared.updateToCache(name: downloadURL, image: selectedImage)
                    } catch {
                        Configs.printDebugMessage("에러: \(error)")
                    }
                }
            }
        } else {
            // 이미지를 설정하지 않았을때
            Task {
                do {
                    let serviceTerm = try await userService.term(type: .service)
                    let privacyTerm = try await userService.term(type: .privacy)
                    let locationTerm = try await userService.term(type: .location)
                    
                    // 유저 정보 모델에 저장
                    let userInfo: UserModel = .init(userID: emailField, userName: nickName, userImage: "", gender: isMan ? .male : .female, birthYear: birthYear, staticGauge: 20.0, agreeServiceDate: serviceTerm.date, agreePrivacyDate: privacyTerm.date, agreeLocationDate: locationTerm.date)
                    
                    // 유저 프로필 서버에 올리기
                    try userService.setUserInfo(uid: registeredUID, info: userInfo)
                    
                } catch {
                    Configs.printDebugMessage("에러: \(error)")
                }
            }
        }
    }
}

#Preview {
    SetProfileView(emailField: "", registeredUID: .constant(""))
}
