//
//  RoomCreateView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/23/24.
//

import SwiftUI

struct RoomCreateView: View {
    let VM = RoomCreateViewModel.shared
    
    @Environment(\.dismiss) private var topDismiss
    
    init() {
        print("RoomCreateView Init")
    }
    
    var body: some View {
        NavigationStack {
            FirstRoomCreateView()
        }
        .onAppear {
            VM.clearSelection()
            VM.topDismiss = topDismiss
        }
    }
}


#Preview {
    RoomCreateView()
}
