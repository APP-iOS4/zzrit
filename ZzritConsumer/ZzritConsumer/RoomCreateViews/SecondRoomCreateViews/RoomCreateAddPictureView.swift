//
//  RoomCreateAddPictureView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI
import PhotosUI

struct RoomCreateAddPictureView: View {
    var body: some View {
        // TODO: 건님께 물어보고, 배운 후, 사진 피커 적용
        
        ZStack {
            Color.staticGray6
                .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
            
            VStack(spacing: 10.0) {
                Image(systemName: "plus")
                    .font(.title2)
                Text("사진 등록")
            }
            .foregroundStyle(Color.staticGray)
        }
        .overlay {
            
        }
    }
}

#Preview {
    RoomCreateAddPictureView()
}
