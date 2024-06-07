//
//  StrengthTrainingView.swift
//  Ringfit
//
//  Created by Chloe Chung on 3/12/24.
//

import SwiftUI

struct StrengthTrainingView: View {
    @ObservedObject var viewModel = StrengthTrainingViewModel()
    @Binding var currentDate: Date
    
    var body: some View {
        VStack {
            Text("근력")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .bold()
                .font(.title)
                .foregroundColor(.black)
            
            HStack(spacing: 5) {
                ForEach(0..<7, id: \.self) { index in
                    let day = dateForWeekdayIndex(index)
                    let isStrengthTrainingDone = viewModel.isStrengthTrainingDone(on: day)
                    

                    ZStack {
                        Circle()
                            .fill(isStrengthTrainingDone ? Color.Main : Color.clear)
                            .frame(width: 35, height: 35)

                        Text(dayFormatter.string(from: day))
                            .foregroundColor(isStrengthTrainingDone ? .white : .black)
                            .padding()
                    }
                }
            }
        }
        .background(
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color.LightGray1)
                    .frame(width: geometry.size.width, alignment: .center)
            }
        )
        .padding()
    }
    
    private func dateForWeekdayIndex(_ index: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.firstWeekday = 2
        let daysToMonday = (calendar.component(.weekday, from: currentDate) - calendar.firstWeekday + 7) % 7
        let mondayThisWeek = calendar.date(byAdding: .day, value: -daysToMonday, to: currentDate)!
        return calendar.date(byAdding: .day, value: index, to: mondayThisWeek)!
    }
    
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "EE"
        return formatter
    }
}


#Preview {
    //    StrengthTrainingView()
    HomeView(cardioAchievementPercentage: 30)
}
