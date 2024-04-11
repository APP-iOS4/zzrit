//
//  IncrementStaticGuageView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/9/24.
//

import SwiftUI

import ZzritKit

struct IncrementStaticGuageView: View {
    private let userService = UserService()
    
    @State private var UIDs: [String] = [
        "tMecHWbZuyYapCJmmiN9AnP9TeQ2",
        "lZJDCklNWnbIBcARDFfwVL8oSCf1"
    ]
    @State private var uidField: String = ""
    var body: some View {
        HStack {
            TextField("UID", text: $uidField)
            Button("추가") {
                addUID()
            }
        }
        .padding()
        
        List {
            ForEach(UIDs, id: \.self) { uid in
                Text(uid)
            }
        }
        
        Button("정전기 지수 높이기") {
            incrementStaticGuage()
        }
    }
    
    private func addUID() {
        UIDs.append(uidField)
        uidField = ""
    }
    
    private func incrementStaticGuage() {
        Task {
            do {
                try await userService.applyEvaluation(userUIDs: UIDs)
                print("정상적으로 정전기 지수를 높였습니다.")
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    IncrementStaticGuageView()
}
