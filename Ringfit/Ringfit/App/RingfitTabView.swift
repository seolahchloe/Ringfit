//
//  RingfitTabView.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/26/24.
//

import SwiftUI

struct RingfitTabView: View {
    @EnvironmentObject var viewModel: SignUpViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @State var selectedTab = "Home"
    @State var cardioAchievementPercentage: Double
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                HomeView(cardioAchievementPercentage: cardioAchievementPercentage)
                    .environmentObject(viewModel)
                    .tag("Home")
                    .tabItem {
                        Image(systemName: "house")
                    }
                
                MyProfileView()
                    .tag("MyProfile")
                    .tabItem {
                        Image(systemName: "person.fill")
                            .foregroundColor(Color.HKNavy)
                    }
            }
            .accentColor(Color.HKNavy)
        }
        // MARK: - 상단 로고
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image("logo_word_black")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 170, height: 2, alignment: .leading)
                }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                if selectedTab == "MyProfile" {
                    NavigationLink {
                        SettingView()
                    } label: {
                        Image(systemName: "gear")
                            .foregroundStyle(Color.HKNavy)
                    }
                }
            }
        }
    }
}
#Preview {
    NavigationStack {
        RingfitTabView(cardioAchievementPercentage: 30)
            .environmentObject(StrengthTrainingViewModel())
            .environmentObject(SignUpViewModel())
            .environmentObject(HealthViewModel())
            .environmentObject(UserViewModel())
    }
}

