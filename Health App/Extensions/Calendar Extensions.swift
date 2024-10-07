//
//  Calendar Extensions.swift
//  Health App
//
//  Created by Hansa Wickramanayake on 2024-10-07.
//

import Foundation

extension Calendar {
    func getLast30Days() -> (Date, Date) {
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: endDate)!
        return (startDate, endDate)
    }
    
    func getAnchorDate(for endDate: Date) -> Date {
        return Calendar.current.startOfDay(for: endDate)
    }
}
