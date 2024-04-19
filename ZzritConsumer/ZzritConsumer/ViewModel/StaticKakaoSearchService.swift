//
//  StaticKakaoSearchService.swift.swift
//  API
//
//  Created by Sanghyeon Park on 2/28/24.
//

import Foundation

class StaticKakaoSearchService.swift: ObservableObject {
    @Published var results: [KakaoSearchDocumentModel] = []
    @Published private var recentKeyword: String = ""
    @Published var isEnd: Bool = false
    @Published var fetchError: KakaoSearchError = .none
    
    private let kakaoRestAPIKey: String
    private let kakaoSearchUrl = "https://dapi.kakao.com/v2/local/search/keyword"
    private var page: Int = 1
    
    init() {
        kakaoRestAPIKey = Bundle.main.object(forInfoDictionaryKey: "Kakao Rest API Key") as? String ?? ""
    }
    
    func fetchKeywordSearchResults(keyword: String) async throws {
        // 검색 단어가 없을 경우, 리스트를 초기화 하고 함수 종료
        if keyword == "" {
            recentKeyword = ""
            results.removeAll()
            return
        }
        
        // 스토어에 저장된 검색어가 달라지지 않은 경우, 다음 페이지 검색으로 간주한다
        if recentKeyword == keyword {
            page += 1
        } else {
            // 새로운 키워드로 검색할 경우 검색 결과 배열을 초기화 한다.
            page = 1
            // 검색 결과를 초기화 한다
            results.removeAll()
        }
        
        // 들어온 키워드를 스토어에 저장함 (페이징 처리를 위해)
        recentKeyword = keyword
        
        // URL 변환에 실패했을 경우 오류 반환
        guard let url = URL(string: "\(kakaoSearchUrl)?query=\(keyword)&page=\(page)") else {
            throw KakaoSearchError.invalidUrl
        }
        
        // APIKey에 이상이 있을 경우 오류 반환
        if kakaoRestAPIKey == "" {
            throw KakaoSearchError.invalidApiKey
        }
        
        // 데이터를 받기 위한 URL Request 생성
        var request = URLRequest(url: url)
        request.addValue("KakaoAK \(kakaoRestAPIKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200...299:
                // 서버로부터 정상적으로 응답받았을때
                let decodedJsonData = try JSONDecoder().decode(KakaoKeywordSearchModel.self, from: data)
                
                // 마지막 페이지 여부를 넣어줌 (페이징을 위해)
                self.isEnd = decodedJsonData.meta.isEnd
                self.results += decodedJsonData.documents
                
            case 300...399:
                throw KakaoSearchError.redirection
            case 400...499:
                throw KakaoSearchError.clientError
            case 500...599:
                throw KakaoSearchError.serverError
            default:
                throw KakaoSearchError.unknowned
            }
        }
    }
}
