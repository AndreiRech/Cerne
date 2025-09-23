//
//  ContribuitionTreeComponent.swift
//  Cerne
//
//  Created by Maria Santellano on 22/09/25.
//

import SwiftUI

struct ContribuitionTreeComponent: View {
    var treeName: String
    var treeCO2: Double
    var treeImage: UIImage
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(uiImage: treeImage)
                .resizable()
                .scaledToFill()
                .frame(width: 174, height: 233)
            
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.55), .clear]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 4) {
                    Image(.treeIcon)
                        .font(.title3)
                    
                    Text(treeName)
                        .font(.body)
                        .fontWeight(.semibold)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 4) {
                        Text(String(format: "%.0f kg", treeCO2))
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("de CO²")
                            .font(.body)
                    }
                    Text("sequestrados")
                        .font(.footnote)
                        .fontWeight(.regular)
                }
                
                
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        .frame(width: 174, height: 233)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        
    }
}
