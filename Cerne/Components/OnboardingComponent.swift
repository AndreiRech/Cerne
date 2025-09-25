//
//  OnboardingComponent.swift
//  Cerne
//
//  Created by Andrei Rech on 25/09/25.
//

import SwiftUI

struct OnboardingComponent: View {
    let image: UIImage
    let title: String
    let description: String
    let isLastPage: Bool
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text(description)
                    .font(.callout)
                    .foregroundStyle(.white)
                
                if isLastPage {
                    Button {
                        onTap()
                    } label: {
                        Text("Começar Agora")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(
                                RoundedRectangle(cornerRadius: 10000)
                                    .foregroundStyle(.primitive1)
                            )
                            .glassEffect()
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 20)
        }
    }
}
