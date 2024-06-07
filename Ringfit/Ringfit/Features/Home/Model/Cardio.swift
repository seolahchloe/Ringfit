//
//  Cardio.swift
//  Ringfit
//
//  Created by Chloe Chung on 3/9/24.
//

import SwiftUI
import HealthKit

struct CardioWorkout: Hashable {
    let name: String
    let percentage: Double
    let date: Date
    let color: Color
    let activityType: HKWorkoutActivityType
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let value: Double
    let label: String
    let legend: Legend
}

struct Legend {
    let color: Color
    let label: String
}

var cardioDummy: [CardioWorkout] = [
    CardioWorkout(name: "고강도 인터벌 트레이닝", percentage: 28, date: Date.now, color: Color.randomWorkoutColor(), activityType: .highIntensityIntervalTraining),
    CardioWorkout(name: "수영", percentage: 20, date: Date.now, color: Color.randomWorkoutColor(), activityType: .swimming),
    CardioWorkout(name: "걷기", percentage: 20, date: Date.now, color: Color.randomWorkoutColor(), activityType: .walking),
    CardioWorkout(name: "러닝", percentage: 30, date: Date.now, color: Color.randomWorkoutColor(), activityType: .running),
    CardioWorkout(name: "천국의 계단", percentage: 13, date: Date.now, color: Color.randomWorkoutColor(), activityType: .stepTraining),
    CardioWorkout(name: "사이클", percentage: 8, date: Date.now, color: Color.randomWorkoutColor(), activityType: .cycling),
]
