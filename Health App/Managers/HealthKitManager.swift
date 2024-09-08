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
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            completion(success, error)
        }
    }
    
    func requestStepsWriteAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        // HealthKit write data types
        let writeTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!
        ]
        
        // Request authorization
        healthStore.requestAuthorization(toShare: writeTypes, read: nil) { (success, error) in
            completion(success, error)
        }
    }
    
    func requestWeightWriteAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        // HealthKit write data types
        let writeTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .bodyMass)!
        ]
        
        // Request authorization
        healthStore.requestAuthorization(toShare: writeTypes, read: nil) { (success, error) in
            completion(success, error)
        }
    }
}
