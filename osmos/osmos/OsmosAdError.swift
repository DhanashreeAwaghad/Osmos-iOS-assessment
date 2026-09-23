//
//  OsmosAdError.swift
//  MyApp
//
//  Created by Dhanshree on 23/09/26.
//


import Foundation
import osmos

enum OsmosAdError: LocalizedError {
    
    case sdkUnavailable
    case noAds
    case invalidAdData
    
    var errorDescription: String? {
        switch self {
        case .sdkUnavailable:
            return "Osmos SDK is not available."
            
        case .noAds:
            return "No advertisements are available."
            
        case .invalidAdData:
            return "The advertisement data is invalid."
        }
    }
}

final class OsmosAdService {
    
    static let shared = OsmosAdService()
    
    private init() {}
        
    private let cliUbid =
        "c27b9ad197765dc9ba51e53r3rb7fb9d5c43eb8f1f7b199367af54c74705424558dd"
    
    private let pageType = "demo_page"
    
    private let adUnit = "banner_ads"
        
    func fetchAds() async throws -> [BannerAd] {
        
        guard let manager = try? OSMOS.shared(),
              let adFetcher = manager.adFetcher() else {
            throw OsmosAdError.sdkUnavailable
        }
        
        let targetingParams: [TargetingParams] = [
            ContextTargeting()
                .keyword("")
        ]
        
        
        let response = await adFetcher.fetchDisplayAdsWithAu(
            cliUbid: cliUbid,
            pageType: pageType,
            productCount: 5,
            adUnits: [adUnit],
            targetingParams: targetingParams,
            onError: { error in
                print("❌ Osmos fetch error: \(error.localizedDescription)")
            }
        )
        
        return try parseResponse(response)
    }
        
    private func parseResponse(_ response: [String: Any]?) throws -> [BannerAd] {
        guard let response,
              let responseContainer = response["response"] as? [String: Any],
              let dataString = responseContainer["data"] as? String,
              let data = dataString.data(using: .utf8) else {
            throw OsmosAdError.invalidAdData
        }

        let payloadObject = try JSONSerialization.jsonObject(with: data)
        guard let payload = payloadObject as? [String: Any],
              let adsByUnit = payload["ads"] as? [String: Any],
              let adRecords = adsByUnit[adUnit] as? [[String: Any]] else {
            throw OsmosAdError.invalidAdData
        }

        return adRecords.compactMap(makeBannerAd)
    }

    private func makeBannerAd(from record: [String: Any]) -> BannerAd? {
        guard let elements = record["elements"] as? [String: Any],
              let imageURLString = stringValue(elements["value"]),
              let imageURL = URL(string: imageURLString),
              let destinationURLString = stringValue(elements["destination_url"]),
              let destinationURL = URL(string: destinationURLString) else {
            return nil
        }

        let uclid = stringValue(record["uclid"])
        let id = uclid ?? stringValue(record["id"]) ?? destinationURL.absoluteString

        return BannerAd(
            id: id,
            imageURL: imageURL,
            destinationURL: destinationURL,
            impressionTrackingURL: stringValue(record["impression_tracking_url"]),
            clickTrackingURL: stringValue(record["click_tracking_url"]),
            uclid: uclid
        )
    }

    private func stringValue(_ value: Any?) -> String? {
        guard let value = value as? String,
              !value.isEmpty else {
            return nil
        }

        return value
    }
    func registerImpression(
        ad: BannerAd,
        position: Int
    ) async {
        
        guard let uclid = ad.uclid else {
            print("⚠️ Missing uclid for impression")
            return
        }
        
        guard let manager = try? OSMOS.shared(),
              let registerEvent = manager.registerEvent() else {
            print("❌ Register event API unavailable")
            return
        }
        
        _ = await registerEvent.registerAdImpressionEvent(
            cliUbid: cliUbid,
            uclid: uclid,
            position: position,
            onError: { error in
                print(
                    "❌ Impression event error: \(error.localizedDescription)"
                )
            }
        )
    }
        
    func registerClick(
        ad: BannerAd
    ) async {
        
        guard let uclid = ad.uclid else {
            print("⚠️ Missing uclid for click")
            return
        }
        
        guard let manager = try? OSMOS.shared(),
              let registerEvent = manager.registerEvent() else {
            print("❌ Register event API unavailable")
            return
        }
        
        let trackingParams = TrackingParams()
            .sellerId("1321cs1")
        
        _ = await registerEvent.registerAdClickEvent(
            cliUbid: cliUbid,
            uclid: uclid,
            trackingParams: trackingParams,
            onError: { error in
                print(
                    "❌ Click event error: \(error.localizedDescription)"
                )
            }
        )
    }
}
