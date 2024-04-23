//
//  RoomCreateView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/23/24.
//

import SwiftUI

struct RoomCreateView: View {
    let VM = RoomCreateViewModel()
    
    @Environment(\.dismiss) private var topDismiss
    
    var body: some View {
        NavigationStack {
            FirstRoomCreateView(VM: VM)
        }
        .onAppear {
            VM.topDismiss = topDismiss
        }
    }
}


#Preview {
    RoomCreateView()
}
