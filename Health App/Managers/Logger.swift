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

func printInfo(with object: AnyObject) {
    Logger.shared.printInfo(with: object)
}

func printError(_ error: Error?) {
    Logger.shared.printError(error)
}

func printError(_ message: String) {
    Logger.shared.printError(message)
}

final class Logger {
    static let shared = Logger()
    
    private init() {}
    
    func printInfo(with message: String) {
        print("🟢 \(message)")
    }
    
    func printInfo(with object: AnyObject) {
        print("🟢 \(object)")
    }
    
    func printError(_ error: Error?) {
        print("🔴 \(error?.localizedDescription ?? "")")
    }
    
    func printError(_ message: String) {
        print("🔴 \(message)")
    }
}
