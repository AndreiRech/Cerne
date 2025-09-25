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
        Map(position: $viewModel.position, selection: .constant(viewModel.selectedPin)) {
            UserAnnotation()
            
            ForEach(viewModel.usablePins) { pin in
                Annotation("", coordinate: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)) {
                    Button {
                        viewModel.selectedPin = pin
                    } label: {
                        TreePinView()
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            
            ForEach(viewModel.metaballs) { metaball in
                Annotation("", coordinate: metaball.coordinate) {
                    Button {
                        if let firstPin = metaball.pins.first {
                            viewModel.selectedPin = firstPin
                        }
                    } label: {
                        MetaballView(metaball: metaball, zoomLevel: viewModel.normalizedZoomLevel)
                            .transition(.scale.combined(with: .opacity))
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
        .onMapCameraChange(frequency: .onEnd) { context in
            let zoomLevel = context.region.span.latitudeDelta
            viewModel.updateMapRegion(zoomLevel: zoomLevel, region: context.region)
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
        .animation(.easeInOut(duration: 0.3), value: viewModel.metaballs.count)
        .animation(.easeInOut(duration: 0.3), value: viewModel.usablePins.count)
    }
}
