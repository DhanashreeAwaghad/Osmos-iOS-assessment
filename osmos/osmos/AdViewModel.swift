//
//  AdViewModel.swift
//  MyApp
//
//  Created by Dhanshree on 23/09/26.
//

import Foundation
import Combine

@MainActor
final class AdViewModel: ObservableObject {
    
    @Published private(set) var ads: [BannerAd] = []
    
    @Published private(set) var isLoading = false
    
    @Published private(set) var errorMessage: String?
    
    @Published private(set) var hasLoaded = false
    
    private var isRequestInProgress = false
    
    
    func loadAds() async {
        
        guard !isRequestInProgress else {
            AnalyticsLogger.shared.info(
                "Duplicate ad request prevented"
            )
            return
        }
        
        isRequestInProgress = true
        
        isLoading = true
        errorMessage = nil
        hasLoaded = false
        
        defer {
            isRequestInProgress = false
            isLoading = false
        }
        
        do {
            
            let fetchedAds =
                try await OsmosAdService.shared.fetchAds()
            
            guard !fetchedAds.isEmpty else {
                ads = []
                errorMessage = "Ad not available"
                return
            }
            
            ads = fetchedAds
            hasLoaded = true
            
            AnalyticsLogger.shared.adLoaded(
                count: fetchedAds.count
            )
            
        } catch {
            
            ads = []
            hasLoaded = false
            
            errorMessage = error.localizedDescription
            
            AnalyticsLogger.shared.adFailed(error)
        }
    }
        
    func retry() async {
        await loadAds()
    }
        
    func fireImpressionIfNeeded(
        for adID: String,
        position: Int
    ) {
        
        guard let index = ads.firstIndex(
            where: { $0.id == adID }
        ) else {
            return
        }
        
        // Prevent duplicate impression.
        guard !ads[index].impressionFired else {
            return
        }
        
        ads[index].impressionFired = true
        
        let ad = ads[index]
        
        AnalyticsLogger.shared.impressionFired(
            adID: ad.id
        )
        
        Task {
            await OsmosAdService.shared.registerImpression(
                ad: ad,
                position: position
            )
        }
    }
    
    // MARK: - Click
    
    func handleClick(
        for ad: BannerAd
    ) {
        
        AnalyticsLogger.shared.clickFired(
            adID: ad.id
        )
        
        Task {
            await OsmosAdService.shared.registerClick(
                ad: ad
            )
        }
    }
}
