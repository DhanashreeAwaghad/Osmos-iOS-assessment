//
//  BannerAd.swift
//  MyApp
//
//  Created by Dhanshree on 23/09/26.
//


import Foundation

struct BannerAd: Identifiable, Equatable {
    
    let id: String
    let imageURL: URL
    let destinationURL: URL
    
    let impressionTrackingURL: String?
    let clickTrackingURL: String?
    
    let uclid: String?
    
    var impressionFired: Bool = false
}
