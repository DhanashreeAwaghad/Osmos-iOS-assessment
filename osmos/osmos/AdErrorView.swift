//
//  AdErrorView.swift
//  MyApp
//
//  Created by Dhanshree on 23/09/26.
//

import SwiftUI

struct AdErrorView: View {
    
    let message: String
    let retry: () -> Void
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            Image(
                systemName: "rectangle.slash"
            )
            .font(.system(size: 40))
            
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                retry()
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(
            maxWidth: .infinity
        )
        .padding()
    }
}
