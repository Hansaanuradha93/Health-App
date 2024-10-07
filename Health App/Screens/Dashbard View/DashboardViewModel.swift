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

final class DashboardViewModel: ObservableObject {
    @Published var selectedTab: DashboardSelectedTab = .steps
    @Published var dailyStepCounts: [Date: Double] = [:]
    
    func fetchSteps() {
        HealthKitManager.shared.fetchDailySteps { dailyStepCounts, error in
            if let error {
                printError(error)
                return
            }
            
            guard let dailyStepCounts else {
                return
            }
            
            DispatchQueue.main.async {
                self.dailyStepCounts = dailyStepCounts
            }
        }
    }
}
