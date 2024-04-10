//
//  RoomCreateViewModel.swift
//  ZzritConsumer
//
//  Created by 이선준 on 4/10/24.
//

import Foundation

import ZzritKit

final class RoomCreateViewModel {
    /// 선택된 모임 카테고리
    private var category: FilterCategory?
    /// 모임 제목
    private var title: String = ""
    /// 모임 이미지
    private var coverImage: String = "ZziritLogoImage"
    /// 모임 소개
    private var content: String = ""
    
    /// 선택 사항들을 확인해서 새 모임 인스턴스를 만들어주는 함수
    private func makeNewRoom() -> RoomModel? {
        // 카테고리 확인
        guard category != nil else {
            print("모임 카테고리가 선택되지 않았거나 저장되지 않음.")
            return nil
        }
        // 모임 제목 확인
        guard !title.isEmpty else {
            print("모임 제목이 입력되지 않았거나 저장되지 않음.")
            return nil
        }
        // 모임 소개 확인
        guard !content.isEmpty else {
            print("모임 소개가 입력되지 않았거나 저장되지 않음.")
            return nil
        }
        
        // 임시로 nil을 리턴하도록 함
        print("새 모임 생성 성공!")
        return nil
    }
    
    /// 선택한 카테고리 저장하는 함수
    func saveSelectedCategory(selection: FilterCategory?) {
        if let selection {
            self.category = selection
            print("선택한 카테고리가 저장됨.")
        } else {
            print("선택한 카테고리가 없어 에러가 발생함!")
        }
    }
    
    /// 새 모임 제목을 저장하는 함수
    func saveNewRoomTitle(title: String) {
        // 저장할 새 모임 제목이 비어있는지 체크해서 비어있다면 리턴, 아니라면 진행
        if title.isEmpty {
            print("새 모임 제목이 없어 에러가 발생함!")
            return
        }
        self.title = title
        print("새 모임 제목이 저장됨.")
    }
    
    /// 새 모임의 소개글을 저장하는 함수
    func saveNewRoomContent(content: String) {
        // 저장할 새 모임 제목이 비어있는지 체크해서 비어있다면 리턴, 아니라면 진행
        if title.isEmpty {
            print("새 모임의 소개글이 없어 에러가 발생함!")
            return
        }
        self.content = content
        print("새 모임의 소개글이 저장됨.")
    }
}
