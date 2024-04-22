//
//  OfflineLocationSearchView.swift
//  ZzritConsumer
//
//  Created by 하윤호 on 4/11/24.
//

import CoreLocation
import SwiftUI

struct OfflineLocationSearchView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let locationService = LocationService()
    private let kakaoService = KakaoSearchService()
    
    @State private var keyword: String = ""
    @State private var selectedTabIndex: Int = 0
    @FocusState private var keywordFocus
    
    
    @Binding var locationCoordinate: CLLocationCoordinate2D?
    @Binding var offlineLocationString: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    TextField("지번, 도로명, 건물명으로 검색", text: $keyword)
                        .foregroundStyle(Color.staticGray2)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(Color.staticGray6)
                        }
                        .overlay {
                            if keywordFocus {
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(Color.staticGray, lineWidth: 2)
                            }
                        }
                        .focused($keywordFocus)
                        .animation(.easeInOut, value: keywordFocus)
                    
                    Button {
                        currentAddress()
                    } label: {
                        HStack {
                            Image("locationPoint")
                            Text("현재 위치로 설정")
                                .font(.callout)
                        }
                    }
                    .tint(.primary)
                    .padding(5)
                }
                .padding(.horizontal, Configs.paddingValue)
                .padding(.bottom, 10)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color.staticGray5)
                
                if #available(iOS 17.0, *) {
                    Rectangle()
                        .foregroundStyle(Color.staticGray6)
                        .frame(height: 5)
                        .onChange(of: keywordFocus) { _, newValue in
                            detectTabIndex(newValue: newValue)
                        }
                } else {
                    Rectangle()
                        .foregroundStyle(Color.staticGray6)
                        .frame(height: 5)
                        .onChange(of: keywordFocus) { newValue in
                            detectTabIndex(newValue: newValue)
                        }
                }
                
                TabView(selection: $selectedTabIndex) {
                    OfflineSearchHistoryView()
                        .tag(0)
                    KakaoSearchResultView(keyword: $keyword)
                        .tag(1)
                }
            }
            .navigationTitle("위치 설정")
            .navigationBarTitleDisplayMode(.inline)
        }
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
    }
    
    private func detectTabIndex(newValue: Bool) {
        if newValue {
            selectedTabIndex = 1
        } else {
            if keyword == "" {
                selectedTabIndex = 0
            }
        }
    }
    
    private func currentAddress() {
        Task {
            do {
                guard let currentCoordinate = locationService.currentLocation() else { return }
                locationCoordinate = currentCoordinate
                let result = try await kakaoService.convertAddress(from: currentCoordinate)
                if let address = result.first {
                    if let roadAddress = address.roadAddress {
                        offlineLocationString = "\(roadAddress.region2DepthName) \(roadAddress.roadName)"
                    } else {
                        let address = address.address
                        offlineLocationString = "\(address.region2DepthName) \(address.region3DepthName)"
                    }
                    
                    dismiss()
                }
            } catch {
                print("에러: \(error)")
            }
        }
    }
}

#Preview {
    OfflineLocationSearchView(locationCoordinate: .constant(nil), offlineLocationString: .constant("서울특별시 종로구"))
}
