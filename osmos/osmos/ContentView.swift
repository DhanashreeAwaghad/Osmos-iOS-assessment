//
//  ContentView.swift
//  MyApp
//
//  Created by Dhanshree on 23/09/26.
//


import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel =
        AdViewModel()
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 0) {
                
                Button {
                    
                    Task {
                        await viewModel.loadAds()
                    }
                    
                } label: {
                    
                    Text("Load Ad")
                        .font(.headline)
                        .frame(
                            maxWidth: .infinity
                        )
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .disabled(
                    viewModel.isLoading
                )
                
                content
            }
            .navigationTitle("Osmos Ads")
        }
    }
    
    @ViewBuilder
    private var content: some View {
        
        if viewModel.isLoading {
            
            LoadingView()
            
        } else if let error =
                    viewModel.errorMessage {
            
            AdErrorView(
                message: error
            ) {
                
                Task {
                    await viewModel.retry()
                }
            }
            
        } else if viewModel.ads.isEmpty {
            
            VStack(spacing: 12) {
                
                Image(
                    systemName:
                        "rectangle.on.rectangle.slash"
                )
                .font(.system(size: 40))
                
                Text("Ad not available")
                    .font(.headline)
                
                Text(
                    "Tap Load Ad to fetch advertisements."
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            
        } else {
            
            ScrollView {
                
                LazyVStack(spacing: 24) {
                    
                    ForEach(
                        Array(
                            viewModel.ads.enumerated()
                        ),
                        id: \.element.id
                    ) { index, ad in
                        
                        BannerAdView(
                            ad: ad,
                            position: index + 1,
                            onVisible: {
                                
                                viewModel
                                    .fireImpressionIfNeeded(
                                        for: ad.id,
                                        position: index + 1
                                    )
                            },
                            onClick: {
                                
                                viewModel.handleClick(
                                    for: ad
                                )
                            }
                        )
                    }
                }
                .padding(.vertical)
            }
        }
    }
}
