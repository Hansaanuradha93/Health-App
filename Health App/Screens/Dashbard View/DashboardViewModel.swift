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
    
    func fetchSteps() async {
        do {
            let steps = try await HealthKitManager.shared.fetchDailySteps()
            dailyStepCounts = steps
        } catch {
            printError(error)
        }
    }
    
    func fetchWeights() async {
        do {
            let weights = try await HealthKitManager.shared.fetchDailyWeights()
            dailyWeights = weights
        } catch {
            printError(error)
        }
    }
}
