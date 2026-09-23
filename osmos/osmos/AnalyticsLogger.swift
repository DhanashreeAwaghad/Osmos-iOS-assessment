//
//  AnalyticsLogger.swift
//  MyApp
//
//  Created by Dhanshree on 23/09/26.
//


import Foundation

final class AnalyticsLogger {
    
    static let shared = AnalyticsLogger()
    
    private init() {}
    
    func adLoaded(count: Int) {
        print("🟢 Ad Loaded - count: \(count)")
    }
    
    func adFailed(_ error: Error) {
        print("🔴 Ad Failed - \(error.localizedDescription)")
    }
    
    func impressionFired(adID: String) {
        print("👁️ Impression Fired - adID: \(adID)")
    }
    
    func clickFired(adID: String) {
        print("🖱️ Click Fired - adID: \(adID)")
    }
    
    func info(_ message: String) {
        print("ℹ️ \(message)")
    }
}
