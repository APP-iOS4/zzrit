//
//  MainView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/8/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    MainExistView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 0) {
                        Text("ZZ!RIT")
                    }
                    .font(.title2)
                    .fontWeight(.black)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Image(systemName: "bell")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack {
        MainView()
    }
}
