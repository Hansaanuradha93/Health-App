//
//  Calendar Extensions.swift
//  Health App
//
//  Created by Hansa Wickramanayake on 2024-10-07.
//

import Foundation

extension Calendar {
    /// Get last 30 days from today
    func getLast30Days() -> (Date, Date) {
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: endDate)!
        return (startDate, endDate)
    }
    
    /// Get the anchor date from end date
    func getAnchorDate(for endDate: Date) -> Date {
        return Calendar.current.startOfDay(for: endDate)
    }
    
    /// Filter the data for the last 7 days
    func getLast7DaysData(from data: [Date: Double]) -> [Date: Double] {
        guard let lastDate = data.keys.sorted().last else {
            return [:]
        }
            
        // Get the date 7 days ago from last day from data
        guard let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: lastDate) else {
            return [:]
        }
        
        // Filter the data to include only dates in the last 7 days
        let last7DaysData = data.filter { date, _ in
            return date >= sevenDaysAgo && date <= lastDate
        }
        
        return last7DaysData
    }
}
