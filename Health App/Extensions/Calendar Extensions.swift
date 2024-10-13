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
}
