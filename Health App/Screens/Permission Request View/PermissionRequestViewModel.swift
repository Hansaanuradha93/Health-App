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
    
    func requestReadAuthorization() async {
        do {
            let success = try await HealthKitManager.shared.requestReadAuthorization()
            isPermissionGranted = success
            if success {
                printInfo(with: "HealthKit read authorization granted")
            } else {
                printError("HealthKit read authorization failed")
            }
        } catch {
            printError(error)
            isPermissionGranted = false
        }
    }
}
