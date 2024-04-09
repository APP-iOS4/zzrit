//
//  ComplaintManagementView.swift
//  ZzritAdministrator
//
//  Created by Healthy on 4/8/24.
//

import SwiftUI

struct ComplaintManagementView: View {
    @State private var qnaCategory: TempQnaType = .allCase
    @State private var qnaSearchText: String = ""
    @State var pickQnaId: QnaStruct.ID?
    @State private var isShowingModalView = false
    
    var body: some View {
        VStack {
            HStack {
                QnaReasonPickerView(selectReason: $qnaCategory)
                TextField("신고 내용을 입력해주세요.", text: $qnaSearchText)
                    .padding(10.0)
                    .padding(.leading)
                Button {
                    print("검색! with (qnaSearchText)")
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
            List(tempQnaList){ list in
                Button {
                    pickQnaId = list.id
                    isShowingModalView.toggle()
                    print("modal .toggle     pickUserId = list.id")
                } label: {
                    QnaListCell(qnaTitle: list.qnaName, qnaCategory: list.qnaCategory, qnaDate: list.qnaDate)
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
            ComplaintDetailView(qnaId: $pickQnaId, isShowingModalView: $isShowingModalView)
        })
    }
}

struct QnaReasonPickerView: View {
    @Binding var selectReason: TempQnaType
    var body: some View {
        Picker("\(selectReason)", selection: $selectReason){
            Text("문의 종류").tag(TempQnaType.allCase)
            Text("폭언/욕설 사용").tag(TempQnaType.abuse)
            Text("부적절한 모임 개설").tag(TempQnaType.wrongRoom)
            Text("종교 권유").tag(TempQnaType.religion)
            Text("불법 도박 홍보").tag(TempQnaType.gambling)
            Text("음란성 모임 개설").tag(TempQnaType.obscenity)
            Text("기타 사유").tag(TempQnaType.administrator)
        }
        .pickerStyle(.menu)
        .tint(Color.pointColor)
    }
}

struct QnaListCell: View {
    var qnaTitle: String
    var qnaCategory: TempQnaType
    var qnaDate: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(qnaTitle)")
                .fontWeight(.bold)
                .foregroundStyle(.black)
            HStack {
                Text("\(qnaCategory.rawValue)")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.pointColor)
                Text("\(qnaDate)")
                    .foregroundStyle(Color.staticGray2)
            }
        }
        .padding(5)
    }
}

public enum TempQnaType: String, CaseIterable {
    case allCase = "문의 종류"
    case abuse = "폭언/욕설 사용"
    case wrongRoom = "부적절한 모임 개설"
    case religion = "종교 권유"
    case gambling = "불법 도박 홍보"
    case obscenity = "음란성 모임 개설"
    case administrator = "기타 사유"
}

struct QnaStruct: Identifiable {
    var id: UUID = UUID()
    
    let qnaName: String
    let qnaCategory: TempQnaType
    let qnaDate: String
    let qnaContent: String
    let qnaWriter: UUID
}

let tempQnaList: [QnaStruct] = [
    .init(qnaName: "집단으로 성적 수치심을 주는 모임", qnaCategory: .obscenity, qnaDate: "2024-04-01", qnaContent: "모임에서 저에게 집단으로 성적 수치심을 주는 채팅을 보내요.", qnaWriter: UUID()),
    .init(qnaName: "불법도박 위장모임", qnaCategory: .gambling, qnaDate: "2024-04-01", qnaContent: "자꾸만 불법도박사이트 링크를 보내요.", qnaWriter: UUID()),
    .init(qnaName: "단체 욕설", qnaCategory: .abuse, qnaDate: "2024-04-01", qnaContent: "다른 멤버들이 저를 따돌리고 제 부모님을 욕했어요.", qnaWriter: UUID()),
    .init(qnaName: "사이비종교 포교", qnaCategory: .religion, qnaDate: "2024-04-01", qnaContent: "게임 모임인것처럼 위장해서 자꾸만 신천치로 의심되는 비인가 성경공부 강요해요.", qnaWriter: UUID())
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
