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
            if #available(iOS 17.0, *) {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    VStack {
                        if let selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
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
                    .frame(width: 200, height: 200)
                }
                .onChange(of: selectedItem) {
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            selectedImage = UIImage(data: data)
                        }
                    }
                }
            } else {
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    VStack {
                        if selectedImage != nil {
                            Image(uiImage: selectedImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: Configs.cornerRadius))
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
                    .frame(height: 200)
                }
                .onChange(of: selectedItem, perform: { value in
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            selectedImage = UIImage(data: data)
                        }
                    }
                })
            }
        }
    }
}

#Preview {
    RCAddPictureView(selectedImage: .constant(nil))
}
