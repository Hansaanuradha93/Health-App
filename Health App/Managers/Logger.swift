//
//  Logger.swift
//  Health App
//
//  Created by Hansa Wickramanayake on 2024-09-19.
//

import Foundation

func printInfo(with message: String) {
    Logger.shared.printInfo(with: message)
}

func printError(_ error: Error?) {
    Logger.shared.printError(error)
}

final class Logger {
    static let shared = Logger()
    
    private init() {}
    
    func printInfo(with message: String) {
        print("🟢 \(message)")
    }
    
    func printError(_ error: Error?) {
        print("🔴 \(error?.localizedDescription ?? "")")
    }
}
