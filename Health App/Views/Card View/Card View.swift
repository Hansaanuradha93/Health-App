//
//  Card View.swift
//  Health App
//
//  Created by Hansa Wickramanayake on 2024-09-07.
//

import SwiftUI

enum ChartType {
    case bar
    case line
    case circular
    case empty
}

struct CardView: View {
    var icon: String
    var title: String
    var subtitle: String
    var chartType: ChartType
    @State var data: [Date: Double]
    
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
                            .font(.title2)
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
            
            switch chartType {
            case .bar:
                StepsBarChartView(data: data)
            case .line:
                LineChartView()
            case .circular:
                CircularChartView()
            case .empty:
                EmptyView(icon: "chart.bar", title: "No Step Data", subtitle: "Add step count to the Health App")
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
    }
}

#Preview {
    CardView(icon: "figure.walk", title: "Steps", subtitle: "Avg: 0 steps", chartType: .bar, data: [:])
}
