//
//  RoomCreateAddPictureView.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/9/24.
//

import SwiftUI
import PhotosUI

struct RCAddPictureView: View {
    
    @State private var selectedItem: PhotosPickerItem?
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        HStack {
            
            // MARK: 카메라찍기도 해야하나
            // TODO: 사진 접근 허용
            PhotosPicker(selection: $selectedItem, matching: .images) {
//                Rectangle()
                RoundedRectangle(cornerRadius: Configs.cornerRadius)
                    .foregroundStyle(.clear)
                    .frame(height: 180)
                    .background {
                        if let selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 180)
                        } else {
                            RoundedRectangle(cornerRadius: Configs.cornerRadius)
                                .fill(Color.staticGray6)
                                .frame(height: 180)
                                .overlay {
                                    VStack(spacing: 10) {
                                        Image(systemName: "plus")
                                        Text("사진 등록")
                                    }
                                    .foregroundStyle(Color.staticGray1)
                                }
                            
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
                
            }
            .customOnChange(of: selectedItem) { _ in
                Task {
                    if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                        selectedImage = UIImage(data: data)
                    }
                }
            }
        }
    }
}

#Preview {
    RCAddPictureView(selectedImage: .constant(nil))
}
