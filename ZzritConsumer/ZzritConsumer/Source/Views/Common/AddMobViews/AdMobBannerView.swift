//
//  AdMobBannerView.swift
//  ZzritConsumer
//
//  Created by Sanghyeon Park on 4/26/24.
//

import SwiftUI

import GoogleMobileAds

struct AdMobBannerView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIViewController()
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let bannerSize = GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth(scene.screen.bounds.width)
            let banner = GADBannerView(adSize: bannerSize)
            banner.rootViewController = viewController
            viewController.view.addSubview(banner)
            viewController.view.frame = CGRect(origin: .zero, size: bannerSize.size)
            
            banner.adUnitID = "ca-app-pub-3940256099942544/2435281174"
            banner.load(GADRequest())
            
            banner.delegate = context.coordinator
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, GADBannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("bannerViewDidReceiveAd")
        }
        
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        }
        
        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
            print("bannerViewDidRecordImpression")
        }
        
        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
            print("bannerViewWillPresentScreen")
        }
        
        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
            print("bannerViewWillDIsmissScreen")
        }
        
        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
            print("bannerViewDidDismissScreen")
        }
    }
}
