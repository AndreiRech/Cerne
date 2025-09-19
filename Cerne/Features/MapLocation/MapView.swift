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
    
    var body: some View {
        Map(position: .constant(viewModel.position), selection: .constant(viewModel.selectedPin)) {
            UserAnnotation()
            ForEach (viewModel.pins) { pin in
                Annotation("", coordinate: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)) {
                    Button {
                        viewModel.selectedPin = pin
                    } label: {
                        Image(uiImage: UIImage(data: pin.image) ?? UIImage(systemName: "tree.circle.fill")!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 5)
                    }
                }
            }
        }
        .sheet(item: $viewModel.selectedPin) { selectedPin in
                    PinDetailsView(viewModel: PinDetailsViewModel(pin: selectedPin, pinService: PinService()))
                        .presentationDetents([.height(265), .height(500)])
                        .presentationDragIndicator(.visible)
                }
        .ignoresSafeArea()
        .onAppear {
            viewModel.onMapAppear()
        }
        .onChange(of: (viewModel.userLocation)) { _, _ in
            viewModel.refreshLocation()
            viewModel.getPins()
        }
    }
}
