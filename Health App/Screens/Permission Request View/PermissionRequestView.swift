//
//  ContentView.swift
//  Health App
//
//  Created by Hansa Wickramanayake on 2024-09-04.
//

import SwiftUI

struct PermissionRequestView: View {
    @StateObject private var viewModel = PermissionRequestViewModel()
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                VStack(alignment: .leading, spacing: 40) {
                    Image("medical-aid")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fit)
                    
                    Text("Apple Health Integration")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("This app displays your step count and weight data in an interactive chart.\n\nYou can also add or delete Apple Health step count and weight data if you chose. Your data is private and protected.")
                        .font(.headline)
                        .fontWeight(.regular)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                Button("Connect HealthKit") {
                    Task {
                        await viewModel.requestReadAuthorization()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .padding(.bottom)
            }
            .padding(30)
            // If permission is granted -> navigate to Dashboard View
            .onChange(of: viewModel.isPermissionGranted, { _, newValue in
                if newValue {
                    path.append(NavigationDestination.dashboardView)
                }
            })
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .dashboardView:
                    DashboardView()
                }
            }
        }
    }
}

#Preview {
    PermissionRequestView()
}
