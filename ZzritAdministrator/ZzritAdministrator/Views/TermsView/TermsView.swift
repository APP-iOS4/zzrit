//
//  TermsView.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/15/24.
//

import SwiftUI

import ZzritKit

struct TermsView: View {
    private let userService = UserService()
    
    // 공지 뷰모델
    @EnvironmentObject private var termsViewModel: TermsViewModel
    
    // 선택한 약관 종류 - 기본은 개인정보 처리방침
    @State private var selectedTermType: TermType = .privacy
    @State private var isShowingModal: Bool = false
    
    private var dateService = DateService.shared
    
    var body: some View {
        VStack {
            HStack {
                TermsPickerView(selectedTerms: $selectedTermType)
                    .padding(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: Constants.commonRadius)
                            .stroke(Color.staticGray3, lineWidth: 1.0)
                    }
                
                Spacer()
                
                Button {
                    isShowingModal.toggle()
                } label: {
                    StaticTextView(title: "등록", isActive: .constant(true))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                .frame(width: 80)
            }
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(termsViewModel.termsList) { term in
                        TermsListCell(termURLString: term.urlString, termType: term.type, termDateString: dateService.formattedString(date: term.date, format: "yyyy/MM/dd HH:mm"))
                            .padding(5)
                        Divider()
                    }
                }
                .padding(.top, 10)
            }
            .overlay {
                RoundedRectangle(cornerRadius: Constants.commonRadius)
                    .stroke(Color.staticGray3, lineWidth: 1.0)
            }
            .onChange(of: selectedTermType) { _ in
                termsViewModel.loadTerms(type: selectedTermType)
            }
            .onChange(of: isShowingModal) { _ in
                if !isShowingModal {
                    termsViewModel.loadTerms(type: selectedTermType)
                }
            }
            
        }
        .padding(20)
        .sheet(isPresented: $isShowingModal) {
            TermsAddingView(termType: $selectedTermType)
        }
    }
}

struct TermsPickerView: View {
    @Binding var selectedTerms: TermType
    var body: some View {
        Picker("\(selectedTerms)", selection: $selectedTerms){
            // Text("문의 종류").tag(ContactCategory.allCases)
            Text(TermType.privacy.title).tag(TermType.privacy)
            Text(TermType.location.title).tag(TermType.location)
            Text(TermType.service.title).tag(TermType.service)
        }
        .pickerStyle(.menu)
        .tint(Color.pointColor)
    }
}

struct TermsListCell: View {
    var termURLString: String
    var termType: TermType
    var termDateString: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(termURLString)")
                .fontWeight(.bold)
            HStack {
                Text("\(termType.title)")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.pointColor)
                Text("\(termDateString)")
                    .foregroundStyle(Color.staticGray2)
            }
        }
        .padding(5)
    }
}


#Preview {
    TermsView()
        .environmentObject(TermsViewModel())
}
