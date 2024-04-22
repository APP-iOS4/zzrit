//
//  Coordinator.swift
//  StaticTemp
//
//  Created by 이선준 on 4/13/24.
//

import Foundation

class Coordinator: ObservableObject {
    /// 네비게이션 경로
    @Published var mainPath: [PageType] = []
    @Published var searchPath: [PageType] = []
    @Published var chattingPath: [PageType] = []
    @Published var moreInfoPath: [PageType] = []
    /// Tab 선택자
    @Published var tabSelection: TabType = .main
    /// Sheet
    @Published var sheet: Sheet? = nil
    /// Full Screen Cover
    @Published var fullScreenCover: FullScreenCover? = nil
    
    /// page를 경로에 push
    func push(_ page: PageType) {
        switch tabSelection {
        case .main:
            self.mainPath.append(page)
        case .search:
            self.searchPath.append(page)
        case .chatting:
            self.chattingPath.append(page)
        case .moreInfo:
            self.moreInfoPath.append(page)
        }
    }
    
    /// Sheet 보여주기
    func present(sheet: Sheet) {
        self.sheet = sheet
    }
    
    /// Full Screen Cover  보여주기
    func present(fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    /// path 경로에서 pop
    func pop() {
        switch tabSelection {
        case .main:
            self.mainPath.removeLast()
        case .search:
            self.searchPath.removeLast()
        case .chatting:
            self.chattingPath.removeLast()
        case .moreInfo:
            self.moreInfoPath.removeLast()
        }
    }
    
    /// path 경로의 root 화면으로 이동
    func popToRoot() {
        switch tabSelection {
        case .main:
            self.mainPath.removeLast(mainPath.count)
        case .search:
            self.searchPath.removeLast(searchPath.count)
        case .chatting:
            self.chattingPath.removeLast(chattingPath.count)
        case .moreInfo:
            self.moreInfoPath.removeLast(moreInfoPath.count)
        }
    }
    
    /// path 경로의 root 화면으로 이동
    func pop(at index: Int) {
        switch tabSelection {
        case .main:
            self.mainPath.remove(at: mainPath.count - index)
        case .search:
            self.searchPath.remove(at: searchPath.count - index)
        case .chatting:
            self.chattingPath.remove(at: chattingPath.count - index)
        case .moreInfo:
            self.moreInfoPath.remove(at: moreInfoPath.count - index)
        }
    }
    
    /// Sheet를 dismiss
    func dismissSheet() {
        self.sheet = nil
    }
    
    /// Full Screen Cover를 dismiss
    func dissmissFullScreenCover() {
        self.fullScreenCover = nil
    }
    
    /// Path 확인을 위해 print
    func printPath() {
        switch tabSelection {
        case .main:
            if mainPath.isEmpty {
                print("mainPath: []")
            } else {
                print("mainPath: [")
                for page in mainPath {
                    print("\t\(page.description),")
                }
                print("]")
            }
        case .search:
            if searchPath.isEmpty {
                print("searchPath: []")
            } else {
                print("searchPath: [")
                for page in searchPath {
                    print("\t\(page.description),")
                }
                print("]")
            }
        case .chatting:
            if chattingPath.isEmpty {
                print("chattingPath: []")
            } else {
                print("chattingPath: [")
                for page in chattingPath {
                    print("\t\(page.description),")
                }
                print("]")
            }
        case .moreInfo:
            if moreInfoPath.isEmpty {
                print("moreInfoPath: []")
            } else {
                print("moreInfoPath: [")
                for page in moreInfoPath {
                    print("\t\(page.description),")
                }
                print("]")
            }
        }
    }
}
