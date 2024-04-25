//
//  StorageService.swift
//
//
//  Created by Sanghyeon Park on 4/9/24.
//

import UIKit

import FirebaseStorage

@available(iOS 16.0.0, *)
public final class StorageService {
    let firebaseConst = FirebaseConstants()
    
    /// 스토리지 이름 정의
    public enum StorageName: String {
        case profile = "ProfileImage"
        case roomCover = "RoomCoverImage"
        case chatting = "ChattingImage"
    }
    
    /// 이미지 퀄리티 정의
    public enum ImageQuality: Int64 {
        case low = 1
        case medium = 3
        case high = 10
    }
    
    lazy var storageReference = Storage.storage().reference()
    
    public init() { }
    
    /// FirebaseStorage에 이미지를 업로드 합니다.
    /// - Parameters:
    ///     - dirs([StorageService.StorageName: 서브 디렉토리 정의 딕셔너리
    ///     - image(Data): 업로드 할 Data 타입의 이미지
    /// - Returns Optional(String): 업로드 된 이미지의 이미지 경로
    public func imageUpload(dirs: [StorageName: [String]], image: Data) async throws -> String? {
        do {
            if let path = dirs.first {
                let topDir = path.key.rawValue
                
                var rf = storageReference.child(topDir)
                
                for dir in path.value {
                    rf = rf.child(dir)
                }

                let _ = try await rf.putDataAsync(image)
                return rf.fullPath
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
    /// FirebaseStorage로부터 이미지를 가져옵니다.
    /// - Parameters:
    ///     - path(String): 이미지 경로
    ///     - quality(ImageQuality): 이미지의 다운로드 퀄리티
    /// - Returns Optional(UIImage): 다운로드한 이미지
    public func loadImage(path: String, quality: ImageQuality) async throws -> UIImage? {
        do {
            let rf = storageReference.child(path)
            let data = try await rf.data(maxSize: (1024 * 1024) * quality.rawValue)
            return UIImage(data: data)
        } catch {
            throw error
        }
    }
}
