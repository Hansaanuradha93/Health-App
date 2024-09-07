//
//  EmptyView.swift
//  Health App
//
//  Created by Hansa Wickramanayake on 2024-09-07.
//

import SwiftUI

struct EmptyView: View {
    var icon: String
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
            
            Text(title)
                .font(.title3)
                .fontWeight(.medium)
            
            Text(subtitle)
                .font(.subheadline)
                .fontWeight(.regular)
        }
        .foregroundStyle(Color(.systemGray3))
    }
}
#Preview {
    EmptyView(icon: "chart.bar", title: "No Step Data", subtitle: "Add step count to the Health App")
}
