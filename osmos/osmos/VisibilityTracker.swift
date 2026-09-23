//
//  VisibilityTracker.swift
//  MyApp
//
//  Created by Dhanshree on 23/09/26.
//

import SwiftUI

struct VisibilityTracker<Content: View>: View {
    
    let threshold: CGFloat
    let onVisibilityChanged: (Bool) -> Void
    let content: () -> Content
    
    init(
        threshold: CGFloat = 0.5,
        onVisibilityChanged: @escaping (Bool) -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.threshold = threshold
        self.onVisibilityChanged = onVisibilityChanged
        self.content = content
    }
    
    var body: some View {
        
        content()
            .background(
                GeometryReader { geometry in
                    
                    Color.clear
                        .onAppear {
                            checkVisibility(
                                geometry: geometry
                            )
                        }
                        .onChange(
                            of: geometry.frame(
                                in: .global
                            )
                        ) { _ in
                            
                            checkVisibility(
                                geometry: geometry
                            )
                        }
                }
            )
    }
    
    private func checkVisibility(
        geometry: GeometryProxy
    ) {
        
        let frame = geometry.frame(
            in: .global
        )
        
        let screenBounds =
            UIScreen.main.bounds
        
        let visibleRect =
            frame.intersection(screenBounds)
        
        guard !frame.isEmpty else {
            onVisibilityChanged(false)
            return
        }
        
        let visibleArea =
            visibleRect.width *
            visibleRect.height
        
        let totalArea =
            frame.width *
            frame.height
        
        guard totalArea > 0 else {
            onVisibilityChanged(false)
            return
        }
        
        let visiblePercentage =
            visibleArea / totalArea
        
        onVisibilityChanged(
            visiblePercentage >= threshold
        )
    }
}
