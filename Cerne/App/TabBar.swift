//
//  TabBar.swift
//  Cerne
//
//  Created by Andrei Rech on 04/09/25.
//

import SwiftUI

struct TabBar: View {
    
    @State private var mapViewModel: MapViewModelProtocol = MapViewModel()
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                ContentView()
            }
            
            Tab("Map", systemImage: "map.fill") {
                MapView(viewModel: mapViewModel)
            }
            
            Tab("Footprint", systemImage: "arrow.3.trianglepath") {
                ContentView()
            }
        }
    }
}
