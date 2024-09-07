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
                } else {
                    WeightView()
                }
            }
            .navigationTitle("Dashboard")
        }
    }
}

#Preview {
    DashboardView()
}


struct StepsView: View {
    var body: some View {
        VStack(spacing: 20) {
            CardView(title: "Steps", subtitle: "Avg: 0 steps", icon: "figure.walk", detailText: "No Step Data", footerText: "Add step counts to the Health app.")
            
            CardView(title: "Averages", subtitle: "Last 28 Days", icon: "calendar", detailText: "No Step Data", footerText: "Add step counts to the Health app.")
        }
        .padding(.horizontal)
    }
}

struct WeightView: View {
    var body: some View {
        VStack(spacing: 20) {
            CardView(title: "Weight", subtitle: "Avg: 0 kg", icon: "scalemass", detailText: "No Weight Data", footerText: "Add weight data to the Health app.")
            
            CardView(title: "Averages", subtitle: "Last 28 Days", icon: "calendar", detailText: "No Weight Data", footerText: "Add weight data to the Health app.")
        }
        .padding(.horizontal)
    }
}


struct CardView: View {
    var title: String
    var subtitle: String
    var icon: String
    var detailText: String
    var footerText: String
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    HStack(spacing: 15) {
                        Image(systemName: icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                            .fontWeight(.regular)
                        
                        Text(title)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.red)
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
            
            Spacer()
            
            EmptyView(icon: "chart.bar", title: "No Step Data", subtitle: "Add step count to the Health App")
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
