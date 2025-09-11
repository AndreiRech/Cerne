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
                        Image(uiImage: UIImage(data: pin.image ?? Data()) ?? UIImage(systemName: "tree.circle.fill")!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 5)
                    }
                    // OnTap -> PinDetails
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.refreshLocation()
            viewModel.getPins()
        }
        .onChange(of: (viewModel.userLocation)) { _, _ in
            viewModel.refreshLocation()
            viewModel.getPins()
        }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    viewModel.addPin(image: Data(), species: "Especie", height: 1.23232, dap: 1.321)
                } label: {
                    Image(systemName: "plus")
                        .font(.title2.weight(.semibold))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding()
            }
            .sheet(item: .constant(viewModel.selectedPin)) { pin in
                VStack(alignment: .leading, spacing: 10) {
                    Text(pin.tree.species)
                        .font(.largeTitle.bold())
                    Text("Altura: \(String(format: "%.2f", pin.tree.height))m")
                    Text("DAP: \(String(format: "%.1f", pin.tree.dap))cm")
                    Text("CO₂ Sequestrado: \(String(format: "%.2f", pin.tree.totalCO2))kg")
                    Text("Registrado por: \(pin.user.name)")
                }
                .padding()
                .presentationDetents([.fraction(0.3)])
            }
    }
}
