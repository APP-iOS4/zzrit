//
//  ContactListView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ContactListView: View {
    
    let contacts: [ContactModel]
    
    //MARK: - body
    
    var body: some View {
        List (contacts) { contact in
            NavigationLink {
                // 상세 페이지
                // FIXME: 모델 받는 것으로 수정해야 함
                ContactDetailView(contact: contact)
            } label: {
                // 리스트에 보여줄 셀들
                // FIXME: 모델 연동 시 isAnswered가 아닌 모델 받는 것으로 수정해야 함
                ContactListCellView(contact: contact)
            }
        }
        .listStyle(.plain)
        .padding(.vertical, 1)
    }
}

#Preview {
    ContactListView(contacts: [])
}
