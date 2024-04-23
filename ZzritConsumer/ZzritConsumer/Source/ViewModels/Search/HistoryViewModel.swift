//
//  HistoryViewModel.swift
//  ZzritConsumer
//
//  Created by SunJoon Lee on 4/23/24.
//

import Foundation

final class HistoryViewModel: ObservableObject {
    
    // MARK: - stored properties
    
    // 싱글톤 변수
    static let shared = HistoryViewModel()
    
    // 검색 기록 배열
    @Published var histories: [String] = []
    // 최대로 저장할 수 있는 검색 기록 개수
    private let limit: Int = 20
    // 유저 디폴트 키값
    private let userDefaultsKey: String = "Recent Search"
    
    // MARK: - methods
    
    // 검색 기록 저장
    func save(_ history: String) {
        // 값이 없다면 리턴
        if history.isEmpty {
            return
        }
        
        // 만약 저장하려는 검색 기록이 이전에 저장된 거였다면, 위치를 변경한다. (삭제 후 다시 저장한다.)
        let savedIndex: Int? = histories.firstIndex(of: history)
        if let savedIndex {
            // 마지막에 넣어줄 거기 때문에 여기서는 삭제만 한다.
            histories.remove(at: savedIndex)
        }
        
        // 배열의 길이가 최대가 넘으면 가장 앞에 저장한 값을 삭제한다.
        if histories.count >= limit {
            _ = histories.removeFirst()
        }
        
        // 배열에 저장
        histories.append(history)
        
        // 유저 디폴트에 저장
        UserDefaults.standard.set(histories, forKey: userDefaultsKey)
        print("유저 디폴트에 검색 기록 저장")
    }
    
    // 유저 디폴트에서 검색 기록 가져옴
    func load() {
        histories = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String] ?? []
        print("유저 디폴트에서 검색 기록 로드")
    }
    
    func remove(_ history: String) {
        // 만약 저장하려는 검색 기록이 이전에 저장된 거였다면, 위치를 변경한다. (삭제 후 다시 저장한다.)
        let savedIndex: Int? = histories.firstIndex(of: history)
        if let savedIndex {
            // 마지막에 넣어줄 거기 때문에 여기서는 삭제만 한다.
            histories.remove(at: savedIndex)
        }
        // 유저 디폴트에 저장
        UserDefaults.standard.set(histories, forKey: userDefaultsKey)
        print("유저 디폴트에 검색 기록 저장")
    }
    
    func removeAll() {
        histories.removeAll()
        print("검색 기록 초기화")
        // 유저 디폴트에 저장
        UserDefaults.standard.set(histories, forKey: userDefaultsKey)
        print("유저 디폴트에 검색 기록 저장")
    }
}
