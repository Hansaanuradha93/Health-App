//
//  HealthKitManager.swift
//  Health App
//
//  Created by Hansa Wickramanayake on 2024-09-07.
//

import HealthKit

final class HealthKitManager {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()
    
    private init() {}

    func requestHealthKitReadAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        // HealthKit read data types
        let readTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!
        ]
        
        // Request authorization
        requestAutorization(write: nil, read: readTypes, completion: completion)
    }
    
    func requestWriteAuthorizationForSteps(completion: @escaping (Bool, Error?) -> Void) {
        // HealthKit write data types
        let writeTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!
        ]
        
        // Request authorization
        requestAutorization(write: writeTypes, read: nil, completion: completion)
    }
    
    func requestWriteAuthorizationForWeight(completion: @escaping (Bool, Error?) -> Void) {
        // HealthKit write data types
        let writeTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .bodyMass)!
        ]
        
        // Request authorization
        requestAutorization(write: writeTypes, read: nil, completion: completion)
    }
}

// MARK: - Reading Data
extension HealthKitManager {
    func getStepsQuery() -> HKStatisticsCollectionQuery {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let (startDate, endDate) = Calendar.current.getLast30Days()
        
        return getQuery(from: startDate, till: endDate, with: stepType)
    }
    
    func fetchHealthData(with query: HKStatisticsCollectionQuery, completion: @escaping ([Date: Double]?, Error?) -> Void) {
        query.initialResultsHandler = { _, result, error in
            if let statsCollection = result {
                var dailyData: [Date: Double] = [:]
                
                for statistics in statsCollection.statistics() {
                    let date = statistics.startDate
                    let data = statistics.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0
                    dailyData[date] = data
                }
                
                completion(dailyData, nil)
            } else {
                completion(nil, error)
            }
        }
        healthStore.execute(query)
    }
}

// MARK: - Helper Methods
private extension HealthKitManager {
    func requestAutorization(write writeTypes: Set<HKSampleType>?, read readTypes: Set<HKObjectType>?, completion: @escaping (Bool, Error?) -> Void) {
        // Request authorization
        healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { [weak self] (success, error) in
            if success {
                completion(success, error)
            } else {
                self?.requestAutorization(write: writeTypes, read: readTypes, completion: completion)
            }
        }
    }
    
    func getQuery(from startDate: Date, till endDate: Date, with type: HKQuantityType) -> HKStatisticsCollectionQuery {
        let (startDate, endDate) = Calendar.current.getLast30Days()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        return HKStatisticsCollectionQuery(quantityType: type,
                                           quantitySamplePredicate: predicate,
                                           options: .cumulativeSum,
                                           anchorDate: Calendar.current.getAnchorDate(for: endDate),
                                           intervalComponents: DateComponents(day: 1))
    }
}
