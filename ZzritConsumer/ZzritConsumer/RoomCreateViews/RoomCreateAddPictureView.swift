//
//  RoomCreateAddPictureView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI
import PhotosUI

struct RoomCreateAddPictureView: View {
    // 이미지 피커를 보여줄 변수
    @State private var showPicker: Bool = false
    // 저장될 이미지가 담길 변수
    @State private var selectedImage: UIImage?
    
    var body: some View {
        Button {
            showPicker.toggle()
        } label: {
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 40, height: 100)
                    .cornerRadius(Configs.cornerRadius)
            } else {
                Rectangle()
                    .fill(Color.staticGray6)
                    .cornerRadius(Configs.cornerRadius)
                    .frame(height: 180.0)
                    .overlay {
                        VStack(spacing: Configs.paddingValue) {
                            Image(systemName: "plus")
                            Text("사진 등록")
                        }
                        .foregroundStyle(Color.staticGray1)
                    }
            }
        }
    }
}

#Preview {
    RoomCreateAddPictureView()
}
