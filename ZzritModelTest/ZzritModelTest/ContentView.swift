//
//  ContentView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/8/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            NavigationLink("로그인") {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
