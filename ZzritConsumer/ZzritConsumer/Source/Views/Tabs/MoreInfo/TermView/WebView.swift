//
//  WebView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/17/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL?
    
    func makeUIView(context: Context) -> some WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: UIViewType, context: Context) {
        guard let url = url else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
}
