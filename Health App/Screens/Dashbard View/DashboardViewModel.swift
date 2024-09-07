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
}
