//
//  HealthData.swift
//  Ringfit
//
//  Created by Chloe Chung on 3/12/24.
//

import SwiftUI
import HealthKit

struct HealthData {
    let healthStore = HKHealthStore()
    
    func loadStrengthTrainingData(completion: @escaping ([Date]) -> Void) {
        let typesToRead = Set([
            HKObjectType.workoutType()
        ])
        
        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            if success {
                var predicates = [NSPredicate]()
                                for type in strengthTrainingTypes {
                                    let predicate = HKQuery.predicateForWorkouts(with: type)
                                    predicates.append(predicate)
                                }
                let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
                
                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
                
                let query = HKSampleQuery(sampleType: .workoutType(), predicate: compoundPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, samples, error in
                                    guard let samples = samples as? [HKWorkout] else {
                                        completion([])
                                        return
                                    }
                    
                    let dates = samples.map { $0.startDate }
                    completion(dates)
                }
                
                self.healthStore.execute(query)
            } else {
                completion([])
            }
            
        }
    }
}
