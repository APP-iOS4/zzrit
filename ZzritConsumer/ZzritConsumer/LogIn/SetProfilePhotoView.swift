//
//  SetProfilePhotoView.swift
//  ZzritConsumer
//
//  Created by Irene on 4/9/24.
//

import SwiftUI

struct SetProfilePhotoView: View {
    var body: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Color.staticGray4)
    }
}

#Preview {
    SetProfilePhotoView()
}
