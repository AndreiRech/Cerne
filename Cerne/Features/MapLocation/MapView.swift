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
                        Image("PinImage")
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
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
        .onAppear {
            viewModel.onMapAppear()
        }
        .onChange(of: (viewModel.userLocation)) { _, _ in
            viewModel.getPins()
        }
        .sheet(item: $viewModel.selectedPin, onDismiss: {
            viewModel.getPins()
        }) { selectedPin in
            PinDetailsView(viewModel: PinDetailsViewModel(pin: selectedPin, pinService: PinService(), userService: UserService(), userDefaultService: UserDefaultService()))
                .presentationDetents([.height(265), .height(500)])
                .presentationDragIndicator(.visible)
        }
    }
}
