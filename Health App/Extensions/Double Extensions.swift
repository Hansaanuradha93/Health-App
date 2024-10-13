//
//  Double Extensions.swift
//  Health App
//
//  Created by Hansa Wickramanayake on 2024-10-13.
//

import Foundation

extension Double {
    /// Use NumberFormatter to format the number with commas
    func formatWithCommas() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
