//
//  Calendar+Extensions.swift
//  Ringfit
//
//  Created by Chloe Chung on 3/12/24.
//

import Foundation

//extension Calendar {
//    var startOfWeek: Date {
//        let date = Date()
//        let dayOfWeek = self.component(.weekday, from: date)
//        let weekdays = self.range(of: .weekday, in: .weekOfYear, for: date)!
//        let daysToAdd = (weekdays.lowerBound + 1) - dayOfWeek
//        let startOfWeek = self.date(byAdding: .day, value: daysToAdd, to: date)!
//        return self.startOfDay(for: startOfWeek)
//    }
//    
//    func dateRangeOfWeek(for date: Date) -> (start: Date, end: Date)? {
//        var calendar = self
//        calendar.firstWeekday = 2 // 월요일을 첫째날로 설정
//        
//        var startDate: Date = Date()
//        var interval: TimeInterval = 0
//        guard calendar.dateInterval(of: .weekOfYear, start: &startDate, interval: &interval, for: date) else {
//            return nil
//        }
//        
//        let endDate = startDate.addingTimeInterval(interval - 1)
//        return (start: startDate, end: endDate)
//    }
//}

extension Calendar {
    var startOfWeek: Date {
        let date = Date()
        let dayOfWeek = self.component(.weekday, from: date)
        let weekdays = self.range(of: .weekday, in: .weekOfYear, for: date)!
        let daysToAdd = (weekdays.lowerBound + 1) - dayOfWeek
        let startOfWeek = self.date(byAdding: .day, value: daysToAdd, to: date)!
        return self.startOfDay(for: startOfWeek)
    }
    
    func datesOfWeek(for date: Date) -> [Date]? {
           var calendar = self
           calendar.firstWeekday = 2 // 월요일을 첫째날로 설정
           
           var startDate: Date = Date()
           var interval: TimeInterval = 0
           guard calendar.dateInterval(of: .weekOfYear, start: &startDate, interval: &interval, for: date) else {
               return nil
           }
           
           let endDate = startDate.addingTimeInterval(interval - 1)
           var dates: [Date] = []
           var currentDate = startDate
           while currentDate <= endDate {
               dates.append(currentDate)
               currentDate = self.date(byAdding: .day, value: 1, to: currentDate)!
           }
           return dates
       }
}
