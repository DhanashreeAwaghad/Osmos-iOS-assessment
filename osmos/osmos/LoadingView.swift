//
//  LoadingView.swift
//  MyApp
//
//  Created by Dhanshree on 23/09/26.
//


import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        
        VStack(spacing: 12) {
            
            ProgressView()
            
            Text("Loading advertisement...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity
        )
        .frame(
            minHeight: 200
        )
    }
}
