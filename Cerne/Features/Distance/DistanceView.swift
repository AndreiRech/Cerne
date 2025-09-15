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
        }
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
    }
}
