//
//  VoteProfileView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/16/24.
//

import SwiftUI

struct VoteProfileView: View {
    @State private var userImage: UIImage?
    
    let nickname: String
    let image: String
    let selected: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            if let userImage = userImage {
                Image(uiImage: userImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.circle)
                    .overlay {
                        if selected {
                            Circle()
                                .stroke(style: .init(lineWidth: 2))
                                .foregroundStyle(Color.pointColor)
                        }
                    }
            } else {
                Image("noProfile")
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                    .clipShape(.circle)
                    .overlay {
                        if selected {
                            Circle()
                                .stroke(style: .init(lineWidth: 2))
                                .foregroundStyle(Color.pointColor)
                        }
                    }
            }
            Text(nickname)
                .font(.title3)
        }
        .onAppear {
            Task {
                if image != "NONE" {
                    userImage = await ImageCacheManager.shared.findImageFromCache(imagePath: image)
                }
            }
        }
    }
}

#Preview {
    VoteProfileView(nickname: "예지님", image: "https://picsum.photos/100/100", selected: true)
}
