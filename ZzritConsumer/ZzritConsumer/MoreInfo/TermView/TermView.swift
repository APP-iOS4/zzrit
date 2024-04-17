//
//  TermView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/17/24.
//

import SwiftUI

import ZzritKit

struct TermView: View {
    @EnvironmentObject private var userService: UserService
    
    @State private var term: TermModel? = nil
    
    let type: TermType
    
    var body: some View {
        VStack {
            if term == nil {
                Text("이용약관을 불러오고 있습니다.")
            } else {
                WebView(url: term?.url)
                    .navigationTitle(term?.type.title ?? "이용약관")
                    .toolbarRole(.editor)
            }
        }
        .onAppear {
            fetchTerm()
        }
    }
    
    private func fetchTerm() {
        Task {
            do {
                term = try await userService.term(type: type)
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

//#Preview {
//    TermView()
//}
