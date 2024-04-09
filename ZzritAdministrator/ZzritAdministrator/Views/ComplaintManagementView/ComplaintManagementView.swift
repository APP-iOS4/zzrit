//
//  ComplaintManagementView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

// TODO: Complaint가 들어간 뷰 파일명 모델에 맞추어 Contact로 변경, ContentView 목록의 신고도 문의로 변경 필요

import SwiftUI

import ZzritKit

struct ComplaintManagementView: View {
    @State private var contactCategory: ContactCategory = .app
    @State private var contactSearchText: String = ""
    @State var pickedContact: ContactModel?
    @State private var isShowingModalView = false
    
    var body: some View {
        VStack {
            HStack {
                ContactReasonPickerView(selectReason: $contactCategory)
                TextField("문의 내용을 입력해주세요.", text: $contactSearchText)
                    .padding(10.0)
                    .padding(.leading)
                Button {
                    print("검색!")
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.pointColor)
                        .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(bottomTrailing: 10, topTrailing: 10)))
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white)
                    .shadow(radius: 10)
            }
            List(tempContactList){ list in
                Button {
                    pickedContact = list
                    isShowingModalView.toggle()
                    print("modal .toggle     pickUserId = list.id")
                } label: {
                    ContactListCell(contactTitle: list.title, contactCategory: list.category, contactDate: list.requestedDated)
                }
            }
            .listStyle(.inset)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.staticGray3, lineWidth: 1.0)
            }
        }
        .padding()
        .fullScreenCover(isPresented: $isShowingModalView, content: {
            ComplaintDetailView(contact: $pickedContact, isShowingModalView: $isShowingModalView)
        })
    }
}

struct ContactReasonPickerView: View {
    @Binding var selectReason: ContactCategory
    var body: some View {
        Picker("\(selectReason)", selection: $selectReason){
            // Text("문의 종류").tag(ContactCategory.allCases)
            Text("앱 이용 문의").tag(ContactCategory.app)
            Text("회원 신고").tag(ContactCategory.mamber)
            Text("모임 신고").tag(ContactCategory.room)
        }
        .pickerStyle(.menu)
        .tint(Color.pointColor)
    }
}

struct ContactListCell: View {
    var contactTitle: String
    var contactCategory: ContactCategory
    var contactDate: Date
    var contactDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString: String = formatter.string(from: contactDate)
        return dateString
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(contactTitle)")
                .fontWeight(.bold)
                .foregroundStyle(.black)
            HStack {
                Text("\(contactCategory.rawValue)")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.pointColor)
                Text("\(contactDateString)")
                    .foregroundStyle(Color.staticGray2)
            }
        }
        .padding(5)
    }
}

let tempContactList: [ContactModel] = [
    .init(category: .room, title: "집단으로 성적 수치심을 주는 모임 신고", content: "모임에서 저에게 집단으로 성적 수치심을 주는 채팅을 보내요.", requestedDated: Date(), requestedUser: "abcd1@example.com", targetRoom: "신촌에서 맥주마실 분 구합니다"),
    .init(category: .room, title: "집단따돌림 모임 신고", content: "다른 멤버들이 저를 따돌리고 제 부모님을 욕했어요.", requestedDated: Date(), requestedUser: "abcd2@example.com", targetRoom: "배틀그라운드 초보자 모임"),
    .init(category: .mamber, title: "사이비종교 포교 사용자 신고", content: "모임 내에서 자꾸만 세계종말론 설파하며 비인가 성경공부 강요해요.", requestedDated: Date(), requestedUser: "abcd3@example.com", targetUser: ["saibi@example.com"]),
    .init(category: .mamber, title: "정치 선동 사용자 신고", content: "자꾸만 특정 정당 후보 투표 강요하고 타 정당 비하발언해요. ", requestedDated: Date(), requestedUser: "abcd4@example.com", targetUser: ["politician@example.com", "jeongdang@example.com", "voteme@example.com"]),
    .init(category: .app, title: "앱 오류 신고", content: "모임 생성이 안 돼요.", requestedDated: Date(), requestedUser: "abcd4@example.com"),
    .init(category: .app, title: "제재 해제 문의", content: "계정이 해킹당해서 도박사이트 링크가 뿌려졌습니다. 복구 가능할까요?", requestedDated: Date(), requestedUser: "abcd4@example.com"),
]

struct writerUser: Identifiable {
    var id: UUID = UUID()
    
    let userID: String
    let staticIndex: Int
    let birthYear: Int
    let gender: GenderType
}

#Preview {
    ComplaintManagementView()
}
