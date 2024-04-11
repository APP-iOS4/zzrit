//
//  ContactInputView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ContactInputView: View {
    // 문의 제목 스트링 변수
    @State private var contactTitle: String = ""
    // 문의 내용 스트링 변수
    @State private var contactContent: String = ""
    // 문의 카테고리 변수
    @State private var selectedContactCategory: ContactCategory = .app
    // 문의할 모임 변수
    @State private var selectedRoomContact: String = ""
    // '문의하기'버튼을 눌렀을 시
    @State private var isPressContactButton: Bool = false
    // 임시 모임 배열 변수 - 모델 주입 시 삭제될 변수
    let rooms: [String] = [
        "수요일에 맥주 한잔 찌그려요~",  "같이 모여서 가볍게 치맥하실 분 구해요!",  "비즈니스 영어회화 스터디",  "파직빠직파지직",
    ]
    
    //MARK: - body
    
    var body: some View {
        VStack {
            // 문의 제목을 받는 곳
            TextField("문의 제목을 입력해주세요", text: $contactTitle)
                .foregroundStyle(Color.staticGray1)
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: Configs.cornerRadius)
                        .stroke(Color.staticGray5, lineWidth: 1)
                }
                .tint(Color.pointColor)
                .padding(.bottom, Configs.paddingValue)
            
            // 문의 종류를 받는 곳
            HStack {
                Text("문의 종류")
                
                Spacer()
                
                // Picker를 통해 selectedContactCategory에 값을 바인딩한다.
                Picker("Choose contact category", selection: $selectedContactCategory) {
                    ForEach(ContactCategory.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
            }
            .foregroundStyle(Color.staticGray1)
            .padding(10)
            .overlay {
                RoundedRectangle(cornerRadius: Configs.cornerRadius)
                    .stroke(Color.staticGray5, lineWidth: 1)
            }
            .tint(Color.pointColor)
            .padding(.bottom, Configs.paddingValue)
            
            // 만약 문의 종류가 모임이라면....
            if selectedContactCategory == .room {
                // 문의 종류가 모임 관련 시 어떤 모임인지 선택하는 곳
                HStack {
                    Text("모임")
                    
                    Spacer()
                    
                    // Picker를 통해 selectedRoomContact에 값을 바인딩한다.
                    Picker("Choose room title", selection: $selectedRoomContact) {
                        ForEach(rooms, id: \.self) { room in
                            Text(room)
                        }
                    }
                }
                .foregroundStyle(Color.staticGray1)
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: Configs.cornerRadius)
                        .stroke(Color.staticGray5, lineWidth: 1)
                }
                .tint(Color.pointColor)
                .padding(.bottom, Configs.paddingValue)
            }
        
            // 문의 내용을 작성하는 곳
            TextField("문의 내용을 입력해주세요", text: $contactContent)
                .foregroundStyle(Color.staticGray1)
                .frame(height: 300, alignment: .top)
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: Configs.cornerRadius)
                        .stroke(Color.staticGray5, lineWidth: 1)
                }
                .tint(Color.pointColor)
                .padding(.bottom, Configs.paddingValue)
            
            Spacer()
            
            GeneralButton(isDisabled: contactTitle.isEmpty, "문의하기") {
                isPressContactButton.toggle()
            }
            .navigationDestination(isPresented: $isPressContactButton) {
                ContactInputCompleteView()
            }
        }
        .padding(Configs.paddingValue)
        .toolbarRole(.editor)
    }
}

#Preview {
    NavigationStack {
        ContactInputView()
    }
}
