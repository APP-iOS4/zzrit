//
//  SetProfileView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/8/24.
//

import SwiftUI

struct SetProfileView: View {
    @State var nickName = ""
    @State var isduplicate = false
    
    @State var isMan = true
    @State var isWoman = false
    
    @State var finishProfile = false
    
    var body: some View {
        NavigationStack {
            SetProfilePhotoView()
            UserInputCellView(text: $nickName, title: "별명", symbol: "rectangle.and.pencil.and.ellipsis")
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
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                ArchieveSelectionButtonView(isSelected: isWoman, "여성", tapAction: {
                    isWoman = true
                    isMan = false
                })
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            }
            .padding()
            VStack {
                HStack {
                    Label("출생년도", systemImage: "birthday.cake")
                        .foregroundStyle(Color.staticGray4)
                    Spacer()
                }
                .padding()
                //TODO: Picker
            }
            Spacer()
            // TODO: 성별은 isMan과 isWoman중 true인 것으로 보내기.
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
}

#Preview {
    SetProfileView()
}
