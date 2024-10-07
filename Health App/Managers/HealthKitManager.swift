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
}
