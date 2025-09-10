//
//  MapView.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 09/09/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State var viewModel: MapViewModelProtocol

    init(viewModel: MapViewModelProtocol) {
        self.viewModel = viewModel
    }

    var body: some View {
       Map(position: $viewModel.position) {
           UserAnnotation()
       }
       .ignoresSafeArea()
       .onAppear {
           (viewModel as? MapViewModel)?.refreshLocation()
       }
       .onChange(of: (viewModel as? MapViewModel)?.userLocation) { _ in
           (viewModel as? MapViewModel)?.refreshLocation()
       }

   }
}

#Preview {
    MapView(viewModel: MapViewModel())
}
