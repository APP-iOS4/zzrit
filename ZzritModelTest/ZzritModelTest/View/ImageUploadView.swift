//
//  ImageUploadView.swift
//  ZzritModelTest
//
//  Created by Sanghyeon Park on 4/9/24.
//

import SwiftUI

import ZzritKit

struct ImageUploadView: View {
    private var storageService = StorageService()
    
    @State private var isShowingSheet: Bool = false
    
    @State var selectedUIImage: UIImage?
    @State var image: Image?
    
    var body: some View {
        if let image = image {
            image
                .resizable()
                .clipShape(Circle())
                .frame(width: 120, height: 120)
        } else {
            Image(systemName: "plus.viewfinder")
                .resizable()
                .foregroundColor(.blue)
                .frame(width: 120, height: 120)
        }
        Button("이미지 피커") {
            isShowingSheet.toggle()
        }
        .sheet(isPresented: $isShowingSheet) {
            loadImage()
        } content: {
            ImagePicker(image: $selectedUIImage)
        }
    }
    
    func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        guard let imageData = selectedImage.pngData() else { return }
        Task {
            do {
                let downloadURL = try await storageService.imageUpload(topDir: .profile, dirs: ["userName", "profile"], image: imageData)
                image = Image(uiImage: selectedImage)
                
                print("업로드 완료: \(downloadURL)")
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    ImageUploadView()
}
