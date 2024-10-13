//
//  DashboardView.swift
//  Health App
//
//  Created by Hansa Wickramanayake on 2024-09-07.
//

import SwiftUI
import Charts

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
                    StepsView(data: viewModel.dailyStepCounts)
                } else if viewModel.selectedTab == .weight {
                    WeightView(data: viewModel.dailyWeights)
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
    @State var data: [Date: Double]

    var body: some View {
        VStack(spacing: 20) {
            CardView(icon: "figure.walk", title: "Steps", subtitle: "Avg: 0 steps", chartType: .bar, data: data)
            
            CardView(icon: "calendar", title: "Averages", subtitle: "Last 28 Days", chartType: .circular, data: data)
        }
        .padding()
    }
}

// MARK: - WeightView
struct WeightView: View {
    @State var data: [Date: Double]

    var body: some View {
        VStack(spacing: 20) {
            CardView(icon: "scalemass", title: "Weight", subtitle: "Avg: 0 kg", chartType: .line, data: data)
            
            CardView(icon: "calendar", title: "Averages", subtitle: "Last 28 Days", chartType: .bar, data: data)
        }
        .padding()
    }
}

struct StepsBarChartView: View {
    @State var data: [Date: Double]
    
    var body: some View {
        Chart {
            ForEach(data.keys.sorted(), id: \.self) { date in
                if let steps = data[date] {
                    BarMark(
                        x: .value("Date", date, unit: .day),
                        y: .value("Steps", steps)
                    )
                    .foregroundStyle(Color.red)
                }
            }
        }
        .chartYScale(domain: 0...30000)
    }
}

struct LineChartView: View {
    var body: some View {
        Text("Line Chart")
    }
}

struct CircularChartView: View {
    var body: some View {
        Text("Circular Chart")
    }
}
