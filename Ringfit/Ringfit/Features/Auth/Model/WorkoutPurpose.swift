//
//  WorkoutPurpose.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/27/24.
//

import Foundation

enum WorkoutPurpose: String, Decodable {
    // 건강유지
    case maintain = "건강유지"
    // 체력향상
    case improve = "체력향상"
    
    var workoutPurposeIndex: Int {
        switch self {
        case .maintain:
            return 0
        case .improve:
            return 1
        }
    }
}
