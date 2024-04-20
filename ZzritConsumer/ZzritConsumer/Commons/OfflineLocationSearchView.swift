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
    
    @Binding var locationCoordinate: CLLocationCoordinate2D?
    @Binding var offlineLocationString: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 20) {
                    Button {
                        
                    } label: {
                        Text("지번, 도로명, 건물명으로 검색")
                            .foregroundStyle(Color.staticGray2)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(Color.staticGray5)
                            }
                    }
                    
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
                }
                .padding(Configs.paddingValue)
                
                Rectangle()
                    .frame(height: 5)
                    .foregroundStyle(Color.staticGray5)
            }
            
            ScrollView {
                
            }
            .navigationTitle("위치설정")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func currentAddress() {
        Task {
            do {
                guard let currentCoordinate = locationService.currentLocation() else { return }
                locationCoordinate = currentCoordinate
                let result = try await kakaoService.covertAddress(from: currentCoordinate)
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
