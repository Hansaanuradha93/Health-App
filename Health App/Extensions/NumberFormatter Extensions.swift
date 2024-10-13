//
//  NumberFormatter Extensions.swift
//  Health App
//
//  Created by Hansa Wickramanayake on 2024-10-13.
//

import Foundation

extension NumberFormatter {
    static var shortStyle: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.positiveSuffix = "k"
        formatter.multiplier = 0.001
        return formatter
    }
}
