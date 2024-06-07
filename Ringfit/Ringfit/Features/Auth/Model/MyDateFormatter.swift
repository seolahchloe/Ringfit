//
//  DateFormatter.swift
//  Ringfit
//
//  Created by Chloe Chung on 3/4/24.
//

import Foundation

struct MyDateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
}

