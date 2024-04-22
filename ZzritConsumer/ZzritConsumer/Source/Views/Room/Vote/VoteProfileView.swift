//
//  VoteProfileView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/16/24.
//

import SwiftUI

struct VoteProfileView: View {
    
    let nickname: String
    let image: String
    let selected: Bool
    
    var imageURL: URL? {
        URL(string: image)
    }
    
    var body: some View {
        VStack(spacing: 15) {
            AsyncImage(url: imageURL, scale: 1.0) { phase in
                phase.resizable()
            } placeholder: {
                Circle()
                    .foregroundStyle(Color.staticGray5)
            }
            .aspectRatio(1.0, contentMode: .fit)
            .clipShape(.circle)
            .overlay {
                Circle()
                    .stroke(style: .init(lineWidth: 2))
                    .foregroundStyle(Color.pointColor)
            }
            
            Text(nickname)
                .font(.title3)
        }
    }
}

#Preview {
    VoteProfileView(nickname: "예지님", image: "https://picsum.photos/100/100", selected: false)
}
