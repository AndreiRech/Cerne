//
//  MetaballView.swift
//  Cerne
//
//  Created by Assistant on 24/09/25.
//

import SwiftUI

struct MetaballView: View {
    let metaball: Metaball
    let zoomLevel: Double
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(.green).opacity(0.5),
                            Color(.green).opacity(metaball.intensity)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: dynamicRadius
                    )
                )
                .frame(width: dynamicSize, height: dynamicSize)
                .blur(radius: blurRadius)
        }
        .scaleEffect(scaleEffect)
        .animation(.easeInOut(duration: 0.3), value: zoomLevel)
    }
    
    private var dynamicSize: CGFloat {
        let baseSize: CGFloat = 40
        let countMultiplier = sqrt(Double(metaball.pinCount)) * 10
        let zoomMultiplier = (1.0 - zoomLevel) * 20
        return baseSize + CGFloat(countMultiplier) + CGFloat(zoomMultiplier)
    }
    
    private var dynamicRadius: CGFloat {
        dynamicSize / 2
    }
    
    private var blurRadius: CGFloat {
        // Mais blur = mais efeito de "gosma"
        let baseBlur: CGFloat = 2
        let zoomBlur = CGFloat(zoomLevel) * 8
        return baseBlur + zoomBlur
    }
    
    private var scaleEffect: CGFloat {
        1.0 + CGFloat(zoomLevel) * 0.5
    }
    
    private var fontSize: CGFloat {
        max(10, 14 - CGFloat(zoomLevel) * 5)
    }
}
