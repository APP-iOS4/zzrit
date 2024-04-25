//
//  SetProfilePhotoView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI
import PhotosUI
import ZzritKit

struct SetProfilePhotoView: View {
    @EnvironmentObject private var userService: UserService
    @State private var selectedItem: PhotosPickerItem?
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        HStack {
            
            // MARK: 카메라찍기도 해야하나
            // TODO: 사진 접근 허용
            PhotosPicker(selection: $selectedItem, matching: .images) {
                VStack {
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                    } else {
                        Image("noProfile")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(Color.staticGray3)
                    }
                }
                .frame(width: 200, height: 200)
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
    SetProfileView(isTopDismiss: .constant(false), registeredUID: .constant(""))
}
