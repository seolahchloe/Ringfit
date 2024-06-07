//
//  WorkoutType.swift
//  Ringfit
//
//  Created by Chloe Chung on 4/3/24.
//

import Foundation
import HealthKit

let workoutTypes: Set<HKWorkoutActivityType> = [
    .americanFootball, .archery, .australianFootball, .badminton, .barre,
    .baseball, .basketball, .bowling, .boxing, .cardioDance, .climbing, .cooldown,
    .coreTraining, .cricket, .crossCountrySkiing, .crossTraining, .curling, .cycling,
    .discSports, .downhillSkiing, .elliptical, .equestrianSports, .fencing,
    .fitnessGaming, .fishing, .flexibility, .functionalStrengthTraining, .golf, .gymnastics,
    .handball, .handCycling, .highIntensityIntervalTraining, .hiking, .hockey, .hunting,
    .jumpRope, .kickboxing, .lacrosse, .martialArts, .mindAndBody, .mixedCardio,
    .other, .paddleSports, .pickleball, .pilates, .play,
    .preparationAndRecovery, .racquetball, .rowing, .rugby, .running, .sailing,
    .skatingSports, .snowSports, .snowboarding, .soccer, .socialDance, .softball,
    .squash, .stairClimbing, .stairs, .stepTraining, .surfingSports, .swimBikeRun,
    .swimming, .tableTennis, .taiChi, .tennis, .trackAndField, .traditionalStrengthTraining,
    .transition, .underwaterDiving, .volleyball, .walking, .waterFitness, .waterPolo,
    .waterSports, .wrestling, .yoga
]
let strengthTrainingTypes: Set<HKWorkoutActivityType> = [
    .traditionalStrengthTraining,
    .functionalStrengthTraining,
    .coreTraining,
    .flexibility,
    .pilates, .yoga
]
let cardioWorkoutTypes: Set<HKWorkoutActivityType> = [
    .americanFootball, .archery, .australianFootball, .badminton, .barre, .basketball, .bowling, .boxing,
    .cardioDance, .cricket, .crossCountrySkiing, .crossTraining, .curling,
    .cycling, .discSports, .downhillSkiing, .elliptical, .equestrianSports,
    .fencing, .fitnessGaming, .handball, .handCycling, .highIntensityIntervalTraining,
    .hiking, .hockey, .jumpRope, .kickboxing, .lacrosse, .martialArts, .mixedCardio,
    .paddleSports, .pickleball, .play, .racquetball, .rowing, .rugby, .running,
    .sailing, .skatingSports, .snowSports, .snowboarding, .soccer, .socialDance,
    .squash, .stairClimbing, .stairs, .stepTraining, .surfingSports, .swimBikeRun,
    .swimming, .tableTennis, .tennis, .trackAndField, .volleyball, .walking,
    .waterFitness, .waterPolo, .waterSports, .wrestling,
    .americanFootball, .archery, .baseball, .climbing, .cooldown,
    .coreTraining, .fishing, .flexibility,
    .golf, .gymnastics,
    .hunting,
    .mindAndBody, .other, .preparationAndRecovery, .softball,
    .taiChi,
    .transition, .underwaterDiving
]
