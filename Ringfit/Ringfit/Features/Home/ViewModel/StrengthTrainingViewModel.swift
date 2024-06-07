//
//  StrengthTrainingViewModel.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/26/24.
//

import SwiftUI

class StrengthTrainingViewModel: ObservableObject {
    @Published var strengthTrainingDays: [Date] = []
    private let healthData = HealthData()
    
    init() {
        loadStrengthTrainingData()
    }
    
    func loadStrengthTrainingData() {
        healthData.loadStrengthTrainingData { [weak self] dates in
            DispatchQueue.main.async {
                self?.strengthTrainingDays = dates
            }
        }
    }
    
    func isStrengthTrainingDone(on date: Date) -> Bool {
        return strengthTrainingDays.contains {
            Calendar.current.isDate($0, inSameDayAs: date)
        }
    }
}

