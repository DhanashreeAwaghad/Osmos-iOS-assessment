//
//  BannerAdView.swift
//  MyApp
//
//  Created by Dhanshree on 23/09/26.
//

import SwiftUI

struct BannerAdView: View {
    
    @Environment(\.openURL) private var openURL
    
    let ad: BannerAd
    let position: Int
    
    let onVisible: () -> Void
    let onClick: () -> Void
    
    var body: some View {
        
        VisibilityTracker(
            threshold: 0.5,
            onVisibilityChanged: { visible in
                
                if visible {
                    onVisible()
                }
            }
        ) {
            
            Button {
                
                onClick()
                
                openURL(ad.destinationURL)
                
            } label: {
                
                AsyncImage(
                    url: ad.imageURL
                ) { phase in
                    
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(
                                maxWidth: .infinity
                            )
                            .frame(height: 180)
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(
                                maxWidth: .infinity
                            )
                        
                    case .failure:
                        VStack {
                            Image(
                                systemName:
                                    "photo"
                            )
                            Text(
                                "Unable to load ad"
                            )
                        }
                        .frame(
                            maxWidth: .infinity
                        )
                        .frame(height: 180)
                        
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            .buttonStyle(.plain)
        }
    }
}
