//
//  SplashScreenView.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/26/24.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Image("app_splash(blue_icon)")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
            
        }
    }
}

#Preview {
    SplashScreenView()
}
