//
//  SetProfileView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/8/24.
//

import SwiftUI

import ZzritKit

struct SetProfileView: View {
    @State var selectedImage: UIImage?
    
    @State var nickName = ""
    @State var isduplicate = false
    
    @State var isMan = true
    @State var isWoman = false
    
    @State var birthYear =  Calendar.current.component(.year, from: Date()) - 19
    @State var birthYearPickerShow = false
    
    @State var finishProfile = false
    @State var completeSignUp = false
    
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
            if isduplicate {
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
                GeneralButton(isDisabled: !finishProfile, "다음") {
                    setUserInfo()
                    completeSignUp.toggle()
                }
                .navigationDestination(isPresented: $completeSignUp, destination: {
                    CompleteSignUpView()
                })
                .onChange(of: finishProfile) {
                    
                }
            } else {
                GeneralButton(isDisabled: !finishProfile, "다음") {
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
        if !isduplicate {
            finishProfile = true
        } else {
            finishProfile = false
        }
    }
    
    private func setUserInfo() {
        Task {
            do {
                let serviceTerm = try await userService.term(type: .service)
                let privacyTerm = try await userService.term(type: .privacy)
                let locationTerm = try await userService.term(type: .location)
                
                let userInfo: UserModel = .init(userID: emailField, userName: nickName, userImage: "", gender: isMan ? .male : .female, birthYear: birthYear, staticGauge: 20.0, agreeServiceDate: serviceTerm.date, agreePrivacyDate: privacyTerm.date, agreeLocationDate: locationTerm.date)
                try userService.setUserInfo(uid: registeredUID, info: userInfo)
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    SetProfileView(emailField: "", registeredUID: .constant(""))
}
