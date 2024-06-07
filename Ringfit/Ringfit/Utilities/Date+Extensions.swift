//
//  Date+Extensions.swift
//  Ringfit
//
//  Created by Chloe Chung on 3/9/24.
//

import Foundation


extension Date {
    func firstDayOfWeek(using calendar: Calendar = Calendar.current) -> String {
        var calendar = calendar
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.firstWeekday = 2 // 시작 요일을 월요일로 설정
        
        let today = calendar.startOfDay(for: self)
        let weekday = calendar.component(.weekday, from: today)
        let daysToSubtract = (weekday - calendar.firstWeekday + 7) % 7
        let thisWeekMonday = calendar.date(byAdding: .day, value: -daysToSubtract, to: today)!

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd (E)"
        
        return dateFormatter.string(from: thisWeekMonday)
    }

    func lastDayOfWeek(using calendar: Calendar = Calendar.current) -> String {
        var calendar = calendar
        calendar.locale = Locale(identifier: "ko_KR")
        
        let today = calendar.startOfDay(for: self)
        let weekday = calendar.component(.weekday, from: today)
        let daysToAdd = (7 - weekday + calendar.firstWeekday) % 7
        let thisWeekSunday = calendar.date(byAdding: .day, value: daysToAdd, to: today)!

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd (E)"
        
        return dateFormatter.string(from: thisWeekSunday)
    }
    
    
    // MARK: - Donut Graph용 
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    static var startOfWeekMonday: Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2 // 월요일
        
        return calendar.date(from: components)!
    }
    
    static var oneMonthAgo: Date {
        let calendar = Calendar.current
        let oneMonth = calendar.date(byAdding: .month, value: -1, to: Date())
        return calendar.startOfDay(for: oneMonth!)
    }

}
