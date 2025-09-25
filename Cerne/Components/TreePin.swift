//
//  TreePin.swift
//  Cerne
//
//  Created by Andrei Rech on 24/09/25.
//

import SwiftUI

struct TreePinView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(.green).opacity(0.3),
                            Color(.green)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 20
                    )
                )
        }
        .frame(width: 40, height: 40)
        .shadow(radius: 5)
    }
}
