//
//  SetProfileView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/8/24.
//

import SwiftUI

struct SetProfileView: View {
    @State var selectedImage: UIImage?
    
    @State var nickName = ""
    @State var isduplicate = false
    
    @State var isMan = true
    @State var isWoman = false
    
    @State var birthYear =  Calendar.current.component(.year, from: Date()) - 19
    
    @State var finishProfile = false
    
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
            
            VStack {
                HStack {
                    Label("출생년도", systemImage: "birthday.cake")
                        .foregroundStyle(Color.staticGray4)
                    Spacer()
                }
                .padding()
                BirthYearPickerView(selectedYear: $birthYear)
            }
            Spacer()
            
            // TODO: 성별은 isMan과 isWoman중 true인 것으로 보내기. (enum 반환 함수 만들기)
            if #available(iOS 17.0, *) {
                GeneralButton(isDisabled: !finishProfile, "다음") {
                    
                }
                .onChange(of: finishProfile) {
                    
                }
            } else {
                GeneralButton(isDisabled: !finishProfile, "다음") {
                    
                }
                .onChange(of: finishProfile, perform: { value in
                   
                })
            }
        }
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
}

#Preview {
    SetProfileView()
}
