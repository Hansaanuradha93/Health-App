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
    
    func requestHealthKitAuthorization() {
        HealthKitManager.shared.requestHealthKitAuthorization { success, error in
            if success {
                print("🟢 HealthKit authorization granted")
                DispatchQueue.main.async {
                    self.isPermissionGranted = true
                }
            } else {
                print("🔴 HealthKit authorization denied: \(String(describing: error))")
                DispatchQueue.main.async {
                    self.isPermissionGranted = false
                }
            }
        }
    }
}
