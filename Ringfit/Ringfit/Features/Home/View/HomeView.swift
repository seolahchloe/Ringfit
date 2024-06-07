//
//  HomeView.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/26/24.
//

import SwiftUI

struct DailyWorkoutView: Identifiable {
    let id = UUID()
    let date: Date
    let stepCount: Double
}

struct HomeView: View {
    @State private var currentDate = Date()
    @State var cardioAchievementPercentage: Double = 0.0
    @ObservedObject private var authViewModel = AuthViewModel.shared
    @ObservedObject private var userViewModel = UserViewModel.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // MARK: - 유저 네임 보여주기
            VStack {
                if let nickName = userViewModel.currentUser?.nickName {
                        Text("\(nickName)님, 환영합니다.").font(.title)
                    } else {
                        Text(userViewModel.currentUser?.name ?? "이름없음")
                    }
            }
            .font(.largeTitle)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            
            // MARK: - 그래프 구역
            ScrollView {
                WeeklyDateSelectView(currentDate: $currentDate, cardioAchievementPercentage: $cardioAchievementPercentage) { date in
                    updateCardioData(for: date)
                }
                CardioDonutChartView(currentDate: $currentDate,
                                     cardioAchievementPercentage: $cardioAchievementPercentage)
                StrengthTrainingView(currentDate: $currentDate)
                Spacer()
                
                HStack {
                    GADBannerViewController()
                        .frame(width: UIScreen.main.bounds.size.width, height: 50)
                }
                
                Spacer()
            }
            
            
        }
        .refreshable {
            updateCardioData(for: currentDate)
        }
        
    }
    private func updateCardioData(for date: Date) {
          // 선택된 날짜 구간에 따라 CardioDonutChartView의 데이터 업데이트
          cardioAchievementPercentage = 0.0 // 초기화
      }
}

#Preview {
    NavigationView {
        HomeView(cardioAchievementPercentage: 30)
    }
}
