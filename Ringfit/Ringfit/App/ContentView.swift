//
//  ContentView.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/23/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @ObservedObject private var authViewModel = AuthViewModel.shared
    @StateObject private var launchViewModel = LaunchViewModel()
    @State private var showSplase = true
    
    var body: some View {
        if showSplase {
            SplashScreenView()
                .transition(.opacity)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.showSplase = false
                    }
                }
        } else {
            if Auth.auth().currentUser != nil {
                RingfitTabView(cardioAchievementPercentage: 30)
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(HealthViewModel())
}
