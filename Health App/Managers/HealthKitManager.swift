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
}

// MARK: - Public Methods
extension HealthKitManager {
    func fetchDailySteps(completion: @escaping ([Date: Double]?, Error?) -> Void) {
        fetchHealthData(for: .stepCount, completion: completion)
    }
    
    func fetchDailyWeights(completion: @escaping ([Date: Double]?, Error?) -> Void) {
        fetchHealthData(for: .bodyMass, completion: completion)
    }

    func requestReadAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let readTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!
        ]
        requestAuthorization(toWrite: nil, toRead: readTypes, completion: completion)
    }

    func requestWriteAuthorization(for type: HKQuantityTypeIdentifier, completion: @escaping (Bool, Error?) -> Void) {
        let writeTypes: Set = [
            HKObjectType.quantityType(forIdentifier: type)!
        ]
        requestAuthorization(toWrite: writeTypes, toRead: nil, completion: completion)
    }
}

// MARK: - Private Methods
private extension HealthKitManager {
    func fetchHealthData(for identifier: HKQuantityTypeIdentifier, completion: @escaping ([Date: Double]?, Error?) -> Void) {
        requestReadAuthorization { [weak self] isAuthorized, error in
            guard let self = self,
                    isAuthorized,
                    let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
                completion(nil, error)
                return
            }
            
            let (startDate, endDate) = Calendar.current.getLast30Days()
            let query = self.createQuery(for: quantityType, from: startDate, to: endDate)
            
            self.executeHealthQuery(query, completion: completion)
        }
    }
    
    func requestAuthorization(toWrite writeTypes: Set<HKSampleType>?, toRead readTypes: Set<HKObjectType>?, completion: @escaping (Bool, Error?) -> Void) {
        healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { success, error in
            completion(success, error)
        }
    }

    func createQuery(for quantityType: HKQuantityType, from startDate: Date, to endDate: Date) -> HKStatisticsCollectionQuery {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let anchorDate = Calendar.current.getAnchorDate(for: endDate)
        
        return HKStatisticsCollectionQuery(
            quantityType: quantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: anchorDate,
            intervalComponents: DateComponents(day: 1)
        )
    }

    func executeHealthQuery(_ query: HKStatisticsCollectionQuery, completion: @escaping ([Date: Double]?, Error?) -> Void) {
        query.initialResultsHandler = { _, result, error in
            guard let statsCollection = result else {
                completion(nil, error)
                return
            }
            
            var dailyData: [Date: Double] = [:]
            for statistics in statsCollection.statistics() {
                let date = statistics.startDate
                let value = statistics.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0
                dailyData[date] = value
            }
            
            completion(dailyData, nil)
        }
        healthStore.execute(query)
    }
}
