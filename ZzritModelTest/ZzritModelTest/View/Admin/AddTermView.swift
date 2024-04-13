//
//  AddTermView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/13/24.
//

import SwiftUI

import ZzritKit

struct AddTermView: View {
    private let userService = UserService()
    
    private var terms = TermType.allCases
    @State private var selectedTerm: TermType = .service
    @State private var selectedDate: Date = .now
    @State private var termURL: String = ""
    var body: some View {
        Form {
            Picker("약관 타입", selection: $selectedTerm) {
                ForEach(terms, id: \.self) { term in
                    Text(term.title)
                        .tag(term)
                }
            }
            
            DatePicker("시행 날짜", selection: $selectedDate, displayedComponents: .date)
            
            HStack {
                TextField("약관 URL 입력", text: $termURL)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("등록") {
                    addTerm()
                }
            }
        }
    }
    
    private func addTerm() {
        do {
            let term: TermModel = .init(date: selectedDate, urlString: termURL, type: selectedTerm)
            try userService.addTerm(term: term)
        } catch {
            print("에러: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        AddTermView()
    }
}
