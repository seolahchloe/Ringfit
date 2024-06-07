//
//  HealthViewModel.swift
//  Ringfit
//
//  Created by Chloe Chung on 4/2/24.
//

import Foundation
import HealthKit
import SwiftUI

extension HKWorkoutActivityType {
    var name: String {
        switch self {
        case .highIntensityIntervalTraining:
            return "고강도 인터벌 트레이닝"
        case .swimming:
            return "수영"
        case .walking:
            return "걷기"
        case .running:
            return "러닝"
        case .stairClimbing:
            return "천국의 계단"
        case .cycling:
            return "사이클"
        default:
            return ""
        }
    }
}

enum WorkoutIntensity: Double {
    case veryLight = 1.0
    case light = 2.0
    case moderate = 3.0
    case hard = 4.0
    case maximum = 5.0
    case none = 0.0
}

class HealthViewModel: ObservableObject {
    
    static let shared = HealthViewModel()
    private let healthStore = HKHealthStore()
    private let restingHeartRate: Double = 70 // 예상 안정시 심박수
    
    @Published private(set) var activities: [String: Activity] = [:]
    @Published var allCardioWorkouts: [(name: String, percentage: Double)] = []
       
    init() {
        fetchAllCardioWorkouts()
    }
    
    func executeQuery(_ query: HKQuery) {
            healthStore.execute(query)
        }

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .heartRateRecoveryOneMinute)!,
            HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
            HKWorkoutType.workoutType(),
//            HKSeriesType.workoutRoute(),
        ]
        
        let typesToShare: Set<HKSampleType> = []
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            if let error = error {
                print("HealthKit 접근 권한 요청 실패: \(error.localizedDescription)")
                completion(false)
            } else {
                print("HealthKit 접근 권한 요청 성공 at HealthViewModel")
                completion(success)
            }
        }
    }
    
    func updateDate(for date: Date, byAdding weeks: Int, completion: @escaping (Double) -> Void) {
        if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: date) {
            let calendar = Calendar.current
            let startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: newDate))!
            let endDate = calendar.date(byAdding: .day, value: 6, to: startDate)!
            
            fetchCardioData(for: startDate, endDate: endDate, currentDate: newDate, completion: completion)
        } else {
            print("Error unauthorized: ")
        }
    }
    
    func fetchAllCardioWorkouts() {
        let workoutType = HKObjectType.workoutType()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        var predicates = [NSPredicate]()
        for workoutType in cardioWorkoutTypes {
            let typePredicate = HKQuery.predicateForWorkouts(with: workoutType)
            predicates.append(typePredicate)
        }
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)

        let query = HKSampleQuery(sampleType: workoutType, predicate: compoundPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            guard let workouts = samples as? [HKWorkout], error == nil else {
                return
            }

            let totalDuration = workouts.reduce(0.0) { $0 + $1.duration }

            let allCardioWorkouts = workouts.map { workout -> (name: String, percentage: Double) in
                let percentage = workout.duration / totalDuration * 100
                let name = workout.workoutActivityType.workoutName
                return (name: name, percentage: percentage)
            }

            DispatchQueue.main.async {
                self.allCardioWorkouts = allCardioWorkouts
                print("All cardio workouts: \(allCardioWorkouts)")
            }
        }

        healthStore.execute(query)
    }
    
    // HealthKit 데이터를 가져오는 함수
    func fetchCardioData(for startDate: Date, endDate: Date, currentDate: Date, completion: @escaping (Double) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        print("Start of week: \(startDate), End of week: \(endDate)")

        let query = HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
            guard let workouts = samples as? [HKWorkout], error == nil else {
                completion(0.0)
                return
            }

            var cardioWorkouts: [(name: String, percentage: Double)] = []
            let totalDuration = workouts.reduce(0.0) { $0 + $1.duration }

            for workout in workouts {
                if cardioWorkoutTypes.contains(workout.workoutActivityType) {
                    let percentage = workout.duration / totalDuration * 100
                    let name = workout.workoutActivityType.name
                    cardioWorkouts.append((name: name, percentage: percentage))
                }
            }

            let avgHeartRate = HealthViewModel.shared.fetchAverageHeartRateForWeek(from: currentDate)
            let age = UserViewModel.shared.calculateAge()
            let workoutPurpose = UserViewModel.shared.workoutPurpose
            let targetPoints = HealthViewModel.shared.calculateTargetActivityPoints(age: age, workoutPurpose: workoutPurpose)
            let workoutIntensity = HealthViewModel.shared.calculateWorkoutIntensity(heartRate: avgHeartRate, age: age)
            let achievedPoints = workoutIntensity.points(for: totalDuration)
            let percentage = min(achievedPoints / targetPoints * 100, 100.0)

            completion(percentage)
        }

        HealthViewModel.shared.executeQuery(query)
    }
    
    // 유산소 운동 자동으로 배열에 넣어주기
    func fetchCardioWorkouts(from startDate: Date, to endDate: Date, completion: @escaping ([(name: String, percentage: Double)]) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let workoutType = HKObjectType.workoutType()
        
//        let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
//                guard let workouts = samples as? [HKWorkout] else {
//                    completion([])
//                    return
//                }
        /*디버깅*/
        let query = HKSampleQuery(sampleType: workoutType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            if let error = error {
                print("Error fetching workouts: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let workouts = samples as? [HKWorkout] else {
                completion([])
                return
            }
            /*디버깅*/
                
                print("Fetched workouts @fetchCardioWorkouts: \(workouts)")
            
            let cardioWorkouts = workouts.filter { cardioWorkoutTypes.contains($0.workoutActivityType) }
            let totalDuration = cardioWorkouts.reduce(0.0) { $0 + $1.duration }
            
            let formattedWorkouts = cardioWorkouts.map { workout in
                let percentage = workout.duration / totalDuration * 100
                let name = workout.workoutActivityType.name
                return (name: name, percentage: percentage)
            }
            
            completion(formattedWorkouts)
        }
        
        healthStore.execute(query)
    }
    
    // MARK: - fetchCardioWorkoutData
    func fetchCardioWorkoutData(for startDate: Date, endDate: Date, completion: @escaping ([CardioWorkout]) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let query = HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
            guard let workouts = samples as? [HKWorkout], error == nil else {
                completion([])
                return
            }
            
            var cardioWorkouts: [CardioWorkout] = []
            let totalDuration = workouts.reduce(0.0) { $0 + $1.duration }
            
            
            for workout in workouts {
                if cardioWorkoutTypes.contains(workout.workoutActivityType) {
                    let percentage = workout.duration / totalDuration * 100
                    let name = workout.workoutActivityType.workoutName
                    let date = workout.startDate
                    let cardioWorkout = CardioWorkout(name: name,
                                                      percentage: percentage,
                                                      date: date,
                                                      color: Color.randomWorkoutColor(),
                                                      activityType: workout.workoutActivityType)
                    cardioWorkouts.append(cardioWorkout)
                    print("Workout: \(name), Percentage: \(percentage)%, Date: \(date)")
                }
            }
            
            completion(cardioWorkouts)
        }
        
        healthStore.execute(query)
    }
    
    // 사용자의 운동 목적에 따른 목표 활동량(targetActivityPoints) 계산
    func calculateTargetActivityPoints(age: Int, workoutPurpose: WorkoutPurpose) -> Double {
        let maxHeartRate = try? calculateMaxHeartRate(age: age) ?? 0.0
        
        switch workoutPurpose {
        case .improve:
            return 200.0 // 체력 향상 목표: 200 포인트
        case .maintain:
            return 100.0 // 건강 유지 목표: 100 포인트
        }
    }
    
    // MARK: - Utility Methods
    private func calculateMaxHeartRate(age: Int) throws -> Double {
        if age < 0 {
            throw ExerciseIntensityError.invalidAge
        }
        return 220 - Double(age) // 최대 심박수 공식: 220 - 나이
    }
    
    func calculateWorkoutIntensity(heartRate: Double, age: Int) -> WorkoutIntensity {
        guard let hrm = try? calculateMaxHeartRate(age: age) else {
            return .none // 최대 심박수 계산 실패 시
        }
        
        let hrr = hrm - restingHeartRate // 예상 심박수 예비량 계산
        let percentage = (heartRate - restingHeartRate) / hrr * 100
        
        switch percentage {
        case 91...100:
            return .maximum // 매우 힘듦
        case 81...90:
            return .hard // 힘듦
        case 71...80:
            return .moderate // 보통
        case 61...70:
            return .light // 쉬움
        case 50...60:
            return .veryLight // 매우 쉬움
        default:
            return .none // 운동 강도 계산 불가
        }
    }
    
    private func fetchCurrentWeekStrengthStats(completion: @escaping ([(name: String, duration: Int)]) -> Void) {
        let startOfWeek = Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: Date()).date!
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 7, to: startOfWeek)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfWeek, end: endOfWeek, options: .strictStartDate)
        let query = HKSampleQuery(sampleType: .workoutType(), predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
            guard let workouts = samples as? [HKWorkout], error == nil else {
                completion([])
                return
            }
            
            var strengthWorkouts: [(name: String, duration: Int)] = []
            
            for workout in workouts {
                if strengthTrainingTypes.contains(workout.workoutActivityType) {
                    let duration = Int(workout.duration) / 60
                    let name = workout.workoutActivityType.name
                    strengthWorkouts.append((name: name, duration: duration))
                }
            }
            
            completion(strengthWorkouts)
        }
        
        healthStore.execute(query)
    }
    
    // MyProfileView용
    func fetchRestingHeartRate(completion: @escaping (Double?) -> Void) {
        let healthStore = HKHealthStore()
        let restingHeartRateType = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!

        healthStore.requestAuthorization(toShare: [], read: [restingHeartRateType]) { (success, error) in
            if !success {
                completion(nil)
                return
            }

            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let sampleQuery = HKSampleQuery(sampleType: restingHeartRateType,
                                            predicate: nil,
                                            limit: 1,
                                            sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                guard let samples = samples as? [HKQuantitySample],
                      let mostRecentSample = samples.first,
                      error == nil else {
                    completion(nil)
                    return
                }

                completion(mostRecentSample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute())))
            }

            healthStore.execute(sampleQuery)
        }
    }
    
    func fetchAverageHeartRate(for period: DateComponents, completion: @escaping (Double?) -> Void) {
        let startDate = Calendar.current.date(from: period)!
        let endDate = Calendar.current.date(byAdding: period, to: startDate)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let sortDescriptoer = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        let query = HKSampleQuery(sampleType: .quantityType(forIdentifier: .heartRate)!,
                                  predicate: predicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [sortDescriptoer]) { (query, samples, error) in
            guard let samples = samples as? [HKQuantitySample],
                  error == nil else {
                completion(nil)
                return
            }
            
            var totalHeartRate: Double = 0
            for sample in samples {
                totalHeartRate += sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
            }
            
            let averageHeartRate = totalHeartRate / Double(samples.count)
        }
        
        healthStore.execute(query)
    }
    
    func fetchAverageHeartRateForWeek(from date: Date) -> Double {
        var totalHeartRate: Double = 0.0
        var heartRateCount: Int = 0
        
        let calendar = Calendar.current
        
        guard let startOfWeek = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date).date,
              let endOfWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfWeek) else {
            // startOfWeek 또는 endOfWeek 계산 실패 시 기본값 반환
            return 0.0
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfWeek, end: endOfWeek, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        let query = HKSampleQuery(sampleType: .quantityType(forIdentifier: .heartRate)!,
                                  predicate: predicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            guard let samples = samples as? [HKQuantitySample],
                  error == nil else {
                return
            }
            
            for sample in samples {
                let heartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                totalHeartRate += heartRate
                heartRateCount += 1
            }
        }
        
        healthStore.execute(query)
        
        guard heartRateCount > 0 else {
            return 0.0
        }
        
        return totalHeartRate / Double(heartRateCount)
    }
}

enum ExerciseIntensityError: Error {
    case invalidAge
}
