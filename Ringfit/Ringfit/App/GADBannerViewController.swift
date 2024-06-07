//
//  GADBannerViewController.swift
//  Ringfit
//
//  Created by Chloe Chung on 6/4/24.
//

import Foundation
import GoogleMobileAds
import SwiftUI
import UIKit

struct GADBannerViewController: UIViewControllerRepresentable {

    @State private var banner: GADBannerView = GADBannerView(adSize: GADAdSizeBanner)
    let adSize = GADAdSizeFromCGSize(CGSize(width: UIScreen.main.bounds.size.width, height: 50))

    func makeUIViewController(context: Context) -> UIViewController {
        
        let bannerSize = adSize
        let viewController = UIViewController()
        banner.adSize = bannerSize

        banner.adUnitID = /*"ca-app-pub-3940256099942544/6300978111"*/
        "ca-app-pub-9128888751805101/6768593211"
        banner.rootViewController = viewController
        viewController.view.addSubview(banner)
        viewController.view.frame = CGRect(origin: .zero, size: bannerSize.size)
        banner.load(GADRequest())
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context){
        let bannerSize = adSize
        banner.frame = CGRect(origin: .zero, size: bannerSize.size)
        banner.load(GADRequest())
    }
}

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            GADBannerViewController()
                .frame(width: UIScreen.main.bounds.size.width, height: 50)
        }
    }
}
