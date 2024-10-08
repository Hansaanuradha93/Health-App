//
//  DashboardViewModel.swift
//  Health App
//
//  Created by Hansa Wickramanayake on 2024-09-07.
//

import SwiftUI

enum DashboardSelectedTab {
    case steps
    case weight
}

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var selectedTab: DashboardSelectedTab = .steps
    @Published var dailyStepCounts: [Date: Double] = [:]
    @Published var dailyWeights: [Date: Double] = [:]
    
    func fetchSteps() {
        HealthKitManager.shared.fetchDailySteps { dailyStepCounts, error in
            if let error {
                printError(error)
                return
            }
            
            guard let dailyStepCounts else { return }
            
            self.dailyStepCounts = dailyStepCounts
        }
    }
    
    func fetchWeights() {
        HealthKitManager.shared.fetchDailyWeights { dailyWeights, error in
            if let error {
                printError(error)
                return
            }
            
            guard let dailyWeights else { return }
            
            self.dailyWeights = dailyWeights
        }
    }
}
