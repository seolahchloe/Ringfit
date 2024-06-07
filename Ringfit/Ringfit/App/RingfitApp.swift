//
//  RingfitApp.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/23/24.
//

import SwiftUI
import Firebase
import HealthKit
import AppTrackingTransparency
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // AdMob 광고 시작
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        FirebaseApp.configure()
        
        // HealthKit 접근 권한 요청
        DispatchQueue.main.async {
            self.requestHealthKitAccess()
        }
        
        return true
    }
    
    private func requestHealthKitAccess() {
        HealthViewModel.shared.requestAuthorization { success in
            if success {
                print("HealthKit 접근 권한 요청 성공 at AppDelegate")
            } else {
                print("HealthKit 접근 권한 요청 실패 at AppDelegate")
            }
        }
    }
}

@main
struct YourApp: App {
    //    @StateObject private var manager = StrengthTrainingViewModel()
    @StateObject private var signUpViewModel = SignUpViewModel()
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var healthViewModel = HealthViewModel()
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
            //User has not indicated their choice for app tracking
            //You may want to show a pop-up explaining why you are collecting their data
            //Toggle any variables to do this here
        } else {
            ATTrackingManager.requestTrackingAuthorization { status in
                //Whether or not user has opted in initialize GADMobileAds here it will handle the rest
                GADMobileAds.sharedInstance().start(completionHandler: nil)
            }
        }
    }
    
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(signUpViewModel)
            .environmentObject(userViewModel)
            .environmentObject(healthViewModel)
        }
    }
}
