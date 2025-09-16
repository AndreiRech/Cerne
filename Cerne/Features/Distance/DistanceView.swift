//
//  DistanceView.swift
//  Cerne
//
//  Created by Andrei Rech on 12/09/25.
//

import SwiftUI

struct DistanceView: View {
    @State var viewModel: any DistanceViewModelProtocol

    var body: some View {
        ZStack(alignment: .bottom) {
            ARPreview(service: viewModel.arService)
                .edgesIgnoringSafeArea(.all)
            
            Text(viewModel.distanceText)
                .font(.body)
                .fontWeight(.medium)
                .padding(12)
                .background(Color.black.opacity(0.6))
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 30)
            
            Button {
                viewModel.shouldNavigate = true
                viewModel.getUserLocation()
            } label: {
                Text("Continuar")
            }
        }
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
        .navigationDestination(isPresented: $viewModel.shouldNavigate) {
            HeightView(
                 viewModel: HeightViewModel(
                     cameraService: CameraService(),
                     motionService: MotionService(),
                     scannedTreeService: ScannedTreeService(),
                     userHeight: 1.85,
                     distanceToTree: 5,
                     measuredDiameter: viewModel.measuredDiameter,
                     treeImage: viewModel.treeImage,
                     userLatitude: viewModel.userLatitude,
                     userLongitude: viewModel.userLongitude
                 )
             )
            .navigationBarHidden(false)
        }
    }
}
