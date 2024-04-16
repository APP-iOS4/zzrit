//
//  PageControl.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/16/24.
//

import SwiftUI

struct PageControl: UIViewRepresentable {
    var numberOfPages: Int
    @Binding var currentPage: Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.currentPageIndicatorTintColor = .black
        control.pageIndicatorTintColor = .gray
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
}
