//
//  DashboardView.swift
//  Health App
//
//  Created by Hansa Wickramanayake on 2024-09-07.
//

import SwiftUI

struct DashboardView: View {
        
    @StateObject private var viewModel = DashboardViewModel()
        
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $viewModel.selectedTab) {
                    Text("Steps").tag(DashboardSelectedTab.steps)
                    Text("Weight").tag(DashboardSelectedTab.weight)
                }
                .pickerStyle(.segmented)
                .padding()

                Spacer()
                
                if viewModel.selectedTab == .steps {
                    StepsView()
                } else if viewModel.selectedTab == .weight {
                    WeightView()
                }
            }
            .navigationTitle("Dashboard")
            .onAppear {
                Task {
                    await viewModel.fetchSteps()
                }
            }
            .onChange(of: viewModel.selectedTab) { _, newTab in
                Task {
                    if newTab == .steps {
                        await viewModel.fetchSteps()
                    } else if newTab == .weight {
                        await viewModel.fetchWeights()
                    }
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}

// MARK: - StepsView
struct StepsView: View {
    var body: some View {
        VStack(spacing: 20) {
            CardView(icon: "figure.walk", title: "Steps", subtitle: "Avg: 0 steps")
            
            CardView(icon: "calendar", title: "Averages", subtitle: "Last 28 Days")
        }
        .padding()
    }
}

// MARK: - WeightView
struct WeightView: View {
    var body: some View {
        VStack(spacing: 20) {
            CardView(icon: "scalemass", title: "Weight", subtitle: "Avg: 0 kg")
            
            CardView(icon: "calendar", title: "Averages", subtitle: "Last 28 Days")
        }
        .padding()
    }
}
