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
    var progressColor: Color = .primitivePrimary
    var trackColor: Color = .backgroundSecondary

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
        }
        .frame(height: height) 
    }
}
