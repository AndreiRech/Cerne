//
//  TreeReviewView.swift
//  Cerne
//
//  Created by Maria Santellano on 12/09/25.
//

import SwiftUI

struct TreeReviewView: View {
    @State var viewModel: TreeReviewViewModelProtocol
    
    var body: some View {
        VStack(spacing: 20) {
            // 👇 Conteúdo normal da sua TreeReviewView aqui...
            Text("Revisar Árvore")
                .font(.largeTitle)
            
            Button("Testar createScannedTree") {
                Task {
                    await viewModel.createScannedTree()
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}
