//
//  StorageService.swift
//
//
//  Created by Sanghyeon Park on 4/9/24.
//

import Foundation

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
    
    lazy var storageReference = Storage.storage().reference()
    
    public init() { }
    
    /// FirebaseStorage에 이미지를 업로드 합니다.
    /// - Parameter topDir(FirebaseConstants.StorageName): 최상위 폴더 열거형
    /// - Parameter dirs([String]): 서브 디렉토리 이름 배열
    /// - Parameter image(Data): 업로드 할 Data 타입의 이미지
    /// - Returns (String): 업로드 된 이미지의 String 타입의 URL
    public func imageUpload(topDir: StorageName, dirs: [String], image: Data) async throws -> String {
        do {
            var rf = storageReference.child(topDir.rawValue)
            
            for dir in dirs {
                rf = rf.child(dir)
            }
            
            let _ = try await rf.putDataAsync(image)
            let downloadURL = try await rf.downloadURL().absoluteString
            return downloadURL
        } catch {
            throw error
        }
    }
}
