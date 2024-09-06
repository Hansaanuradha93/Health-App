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

    func requestHealthKitAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        // Define the HealthKit data types
        let readTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!
        ]
        
        let writeTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!
        ]
        
        // Request authorization
        healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { (success, error) in
            completion(success, error)
        }
    }
}
