//
//  HeightView.swift
//  Cerne
//
//  Created by Andrei Rech on 08/09/25.
//

import SwiftUI

struct HeightView<ViewModel: HeightViewModelProtocol>: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            CameraPreview(service: viewModel.cameraService)
                .ignoresSafeArea()
            
            Circle()
                .stroke(Color.white.opacity(0.8), lineWidth: 2)
                .frame(width: 30, height: 30)
            
            VStack {
                Spacer()
                
                VStack(spacing: 12) {
                    Text("Ângulo Atual")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("Altura Estimada da Árvore")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.top)

                    Text(String(format: "%.2f metros", viewModel.estimatedHeight))
                        .font(.system(size: 50, weight: .bold, design: .monospaced))
                        .foregroundColor(.green)
                }
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
                .padding()
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
    }
}
