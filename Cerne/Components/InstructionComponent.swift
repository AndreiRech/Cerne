//
//  InstructionComponent.swift
//  Cerne
//
//  Created by Andrei Rech on 15/09/25.
//

import SwiftUI

struct InstructionComponent: View {
    let imageName: String
    let title: String
    let buttonText: String
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 105) {
            VStack(alignment: .center, spacing: 10) {
                Image(systemName: imageName)
                    .font(.largeTitle)
                    .foregroundColor(.yellow)
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            if #available(iOS 26.0, *) {
                Button {
                    onTap()
                } label: {
                    Text(buttonText)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 13)
                .glassEffect()
            } else {
                Button {
                    onTap()
                } label: {
                    Text(buttonText)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 13)
                .background(.ultraThinMaterial)
                .cornerRadius(1000)
            }
        }
    }
}
