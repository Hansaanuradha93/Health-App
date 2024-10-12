//  HealthKitManager.swift
//  Health App
//
//  Created by Hansa Wickramanayake on 2024-09-07.
//

import HealthKit

// MARK: HealthKitError
enum HealthKitError: Error {
    case unauthorized
}

// MARK: - HealthKitManager
final class HealthKitManager {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()

    private init() {}
}

// MARK: - Public Methods
extension HealthKitManager {
    func fetchDailySteps() async throws -> [Date: Double] {
        try await fetchHealthData(for: .stepCount)
    }
    
    func fetchDailyWeights() async throws -> [Date: Double] {
        try await fetchHealthData(for: .bodyMass)
    }

    func requestReadAuthorization() async throws -> Bool {
        let readTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!
        ]
        return try await requestAuthorization(toWrite: nil, toRead: readTypes)
    }

    func requestWriteAuthorization(for type: HKQuantityTypeIdentifier) async throws -> Bool {
        let writeTypes: Set = [
            HKObjectType.quantityType(forIdentifier: type)!
        ]
        return try await requestAuthorization(toWrite: writeTypes, toRead: nil)
    }
}

// MARK: - Private Methods
private extension HealthKitManager {
    func fetchHealthData(for identifier: HKQuantityTypeIdentifier) async throws -> [Date: Double] {
        let isAuthorized = try await requestReadAuthorization()
        
        guard isAuthorized,
              let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            throw HealthKitError.unauthorized
        }
        
        let (startDate, endDate) = Calendar.current.getLast30Days()
        let query = createQuery(for: quantityType, from: startDate, to: endDate)
        
        return try await executeHealthQuery(query)
    }
    
    func requestAuthorization(toWrite writeTypes: Set<HKSampleType>?, toRead readTypes: Set<HKObjectType>?) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }
    
    func createQuery(for quantityType: HKQuantityType, from startDate: Date, to endDate: Date) -> HKStatisticsCollectionQuery {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let anchorDate = Calendar.current.getAnchorDate(for: endDate)
        
        let options: HKStatisticsOptions = {
            if quantityType == HKQuantityType.quantityType(forIdentifier: .stepCount) {
                return .cumulativeSum
            } else if quantityType == HKQuantityType.quantityType(forIdentifier: .bodyMass) {
                return .discreteAverage // Use average for body mass (weight)
            }
            return []
        }()
        
        return HKStatisticsCollectionQuery(
            quantityType: quantityType,
            quantitySamplePredicate: predicate,
            options: options,
            anchorDate: anchorDate,
            intervalComponents: DateComponents(day: 1)
        )
    }

    func executeHealthQuery(_ query: HKStatisticsCollectionQuery) async throws -> [Date: Double] {
        try await withCheckedThrowingContinuation { continuation in
            query.initialResultsHandler = { _, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let statsCollection = result {
                    var dailyData: [Date: Double] = [:]
                    for statistics in statsCollection.statistics() {
                        let date = statistics.startDate
                        let value = statistics.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0
                        dailyData[date] = value
                    }
                    continuation.resume(returning: dailyData)
                } else {
                    continuation.resume(returning: [:])
                }
            }
            healthStore.execute(query)
        }
    }
}
