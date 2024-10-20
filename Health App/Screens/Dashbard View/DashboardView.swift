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
                
                switch viewModel.selectedTab {
                case .steps:
                    StepsView(data: viewModel.dailyStepCounts, average: viewModel.averageSteps)
                case .weight:
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

struct CardHeaderView: View {
    var icon: String
    var title: String
    var subtitle: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(spacing: 15) {
                    Image(systemName: icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.pink)
                        .fontWeight(.regular)
                    
                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.pink)
                }
                
                Text(subtitle)
                    .fontWeight(.regular)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Image(systemName: "arrow.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15, height: 15)
                .foregroundStyle(.tertiary)
        }
    }
}

// MARK: - StepsView
struct StepsView: View {
    var data: [Date: Double]
    var average: Double

    var body: some View {
        VStack(spacing: 20) {
            
            /// Bar Chart: - Steps
            VStack(spacing: 10) {
                CardHeaderView(icon: "figure.walk", title: "Steps", subtitle: "Avg: \(average.formatWithCommas()) steps")
                
                Spacer()
                
                StepsBarChartView(data: data, average: average)
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
            
            /// Donut Chart: Steps
            VStack(spacing: 10) {
                CardHeaderView(icon: "calendar", title: "Averages", subtitle: "Last 28 Days")
                
                Spacer()
                
                DonutChartView()
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
        }
        .padding()
    }
}

// MARK: - WeightView
struct WeightView: View {
    var data: [Date: Double]

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                CardHeaderView(icon: "scalemass", title: "Weight", subtitle: "Avg: 0 kg")
                
                Spacer()
                
                LineChartView()
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
            
            VStack(spacing: 10) {
                CardHeaderView(icon: "calendar", title: "Averages", subtitle: "Last 28 Days")
                
                Spacer()
                
                LineChartView()
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
        }
        .padding()
    }
}

struct StepsBarChartView: View {
    var data: [Date: Double]
    var average: Double
    
    var body: some View {
        Chart {
            RuleMark(y: .value("Average", average))
                .foregroundStyle(.pink.opacity(0.6))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
            
            ForEach(data.keys.sorted(), id: \.self) { date in
                if let steps = data[date] {
                    BarMark(
                        x: .value("Date", date, unit: .day),
                        y: .value("Steps", steps)
                    )
                    .foregroundStyle(.pink.gradient)
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing) { value in
                /// Add seperator line
                AxisGridLine()
                    .foregroundStyle(.gray.opacity(0.3))
                
                AxisValueLabel {
                    YAxisValueLabel(value)
                }
            }
        }
    }
    
    @ViewBuilder
    func YAxisValueLabel(_ value: AxisValue) -> some View {
        if let intValue = value.as(Int.self) {
            /// Format large numbers as "10k", "15k", etc.
            if intValue > 0 {
                Text(NumberFormatter.shortStyle.string(from: NSNumber(value: intValue)) ?? "")
            } else {
                Text("\(intValue)")
            }
        } else {
            Spacer()
        }
    }
}

struct LineChartView: View {
    var body: some View {
        Text("Line Chart")
    }
}

struct DonutChartView: View {
    var body: some View {
        Text("Donut Chart")
    }
}
