//
//  CustomProgressViewStyle.swift
//  Cerne
//
//  Created by Maria Santellano on 25/09/25.
//

import SwiftUI

import SwiftUI

struct CustomProgressViewStyle: ProgressViewStyle {
    var height: CGFloat = 12
    var cornerRadius: CGFloat = 8
    var trackColor: Color = .CTA
    var progressColor: Color = .primitive1
    var borderColor: Color = .primitive1

    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0

        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundColor(trackColor)

                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: geometry.size.width * progress)
                    .foregroundColor(progressColor)
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: 1)
            )
        }
        .frame(height: height) 
    }
}
