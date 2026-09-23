//
//  OsmosManager.swift
//  MyApp
//
//  Created by Dhanshree on 23/09/26.
//

import Foundation
import osmos

final class OsmosManager {
    
    static let shared = OsmosManager()
    
    private init() {}
    
    func initialize() {
        do {
            try OSMOS.Builder()
                .clientId("10088010")
                .debug(true)
                .buildGlobalInstance()
            
            print("✅ Osmos SDK initialized successfully")
            
        } catch {
            print("❌ Osmos SDK initialization failed: \(error.localizedDescription)")
        }
    }
}
