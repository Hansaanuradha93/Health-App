//
//  PermissionRequestViewModel.swift
//  Health App
//
//  Created by Hansa Wickramanayake on 2024-09-07.
//

import SwiftUI
import HealthKit

final class PermissionRequestViewModel: ObservableObject {
    
    @Published var isPermissionGranted = false
    
    func requestHealthKitReadAuthorization() {
        HealthKitManager.shared.requestHealthKitReadAuthorization { [weak self] success, error in
            if success {
                printInfo(with: "HealthKit read authorization granted")
                DispatchQueue.main.async {
                    self?.isPermissionGranted = true
                }
            } else {
                printError(error)
                self?.requestHealthKitReadAuthorization()
                DispatchQueue.main.async {
                    self?.isPermissionGranted = false
                }
            }
        }
    }
}
