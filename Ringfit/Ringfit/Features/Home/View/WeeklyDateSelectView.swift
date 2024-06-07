//
//  WeeklyDateSelectView.swift
//  Ringfit
//
//  Created by Chloe Chung on 3/9/24.
//

import SwiftUI
import HealthKit

struct WeeklyDateSelectView: View {
    @StateObject private var healthViewModel = HealthViewModel()
    @Binding var currentDate: Date
    @Binding var cardioAchievementPercentage: Double
    var onDateChanged: (Date) -> Void
    
    var body: some View {
        HStack {
            // 이전 일주일 조회
            Button {
                updateDate(byAdding: -1)
            } label: {
                Image(systemName: "arrowtriangle.backward.fill")
                    .foregroundColor(.black)
            }
            
            
            Spacer ()
            
            Text("\(currentDate.firstDayOfWeek())")
            
            Spacer ()
            
            Text("~")
                .font(.callout)
            
            Spacer()
            
            Text("\(currentDate.lastDayOfWeek())")
            
            Spacer()
            
            // 다음 일주일 조회
            Button {
                updateDate(byAdding: 1)
            } label: {
                Image(systemName: "arrowtriangle.right.fill")
                    .foregroundColor(.black)
            }
        }
        .padding()
        
    }

    func updateDate(byAdding weeks: Int) {
        guard let newDate = Calendar.current.date(byAdding: .day, 
                                                  value: weeks * 7,
                                                  to: currentDate) else {
            return
        }
        currentDate = newDate
        onDateChanged(newDate)
    }
}

#Preview {
    HomeView(cardioAchievementPercentage: 30.0)
}
