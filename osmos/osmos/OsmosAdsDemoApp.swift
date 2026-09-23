//
//  OsmosAdsDemoApp.swift
//  MyApp
//
//  Created by Dhanshree on 23/09/26.
//


import SwiftUI

@main
struct OsmosAdsDemoApp: App {
    
    init() {
        OsmosManager.shared.initialize()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
