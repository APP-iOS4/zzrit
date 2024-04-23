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
    
    @State var loadedImage: UIImage? = nil
    @State var pathField: String = ""
    
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
        
        
        TextField("이미지 경로 입력", text: $pathField)
        Button("불러오기") {
            loadImage(path: pathField)
        }
        
        if let loadedImage {
            Image(uiImage: loadedImage)
        }
    }
    
    func loadImage() {
        guard let selectedImage = selectedUIImage else { return }
        guard let imageData = selectedImage.pngData() else { return }
        Task {
            do {
                let imageDir: [StorageService.StorageName: [String]] = [.roomCover: ["ADepth", "BDepth", "CDepth"]]
                let downloadURL = try await storageService.imageUpload(dirs: imageDir, image: imageData)
                //image = Image(uiImage: selectedImage)
                
                print("업로드 완료: \(downloadURL)")
            } catch {
                print("에러: \(error)")
            }
        }
    }
    
    func loadImage(path: String) {
        Task {
            do {
                loadedImage = try await storageService.loadImage(path: path)
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    ImageUploadView()
}
