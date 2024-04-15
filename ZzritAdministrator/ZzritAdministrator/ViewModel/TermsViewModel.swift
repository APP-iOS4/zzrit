//
//  TermsViewModel.swift
//  ZzritAdministrator
//
//  Created by 이우석 on 4/15/24.
//

import Foundation
import ZzritKit

@MainActor
class TermsViewModel: ObservableObject {
    @Published var termsList: [TermModel] = []
    private let userService = UserService()
    
    init() {
        loadTerms(type: .privacy)
    }
    
    /// 이용약관 서버에서 읽어오기
    func loadTerms(type: TermType) {
        Task {
            do {
                termsList = try await userService.terms(type: type)
                print("\(type) \(termsList.count)")
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    /// 이용약관 추가하기
    func addTerms(term: TermModel) {
        guard let _ = URL(string: term.urlString) else {
            print("유효한 URL이 아닙니다. ")
            return
        }
        
        Task{
            do {
                try userService.addTerm(term: term)
                print("등록 성공!")
            } catch {
                print("에러: \(error)")
            }
        }
    }
}
