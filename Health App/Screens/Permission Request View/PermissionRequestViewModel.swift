//
//  PermissionRequestViewModel.swift
//  Health App
//
//  Created by Hansa Wickramanayake on 2024-09-07.
//

import SwiftUI
import HealthKit

@MainActor
final class PermissionRequestViewModel: ObservableObject {
    
    @Published var isPermissionGranted = false
    
    func requestReadAuthorization() {
        HealthKitManager.shared.requestReadAuthorization { [weak self] success, error in
            if success {
                printInfo(with: "HealthKit read authorization granted")
                self?.isPermissionGranted = true
            } else {
                printError(error)
                self?.requestReadAuthorization()
                self?.isPermissionGranted = false
            }
        }
    }
}
