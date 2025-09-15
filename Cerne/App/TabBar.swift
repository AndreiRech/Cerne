//
//  TabBar.swift
//  Cerne
//
//  Created by Andrei Rech on 04/09/25.
//

import SwiftUI

struct TabBar: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var quickActionService: QuickActionService
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            MapView(viewModel: MapViewModel(locationService: LocationService(), pinService: PinService(modelContext: modelContext), userService: UserService(modelContext: modelContext), scannedTreeService: ScannedTreeService(modelContext: modelContext)))
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(1)
            
            ContentView()
                .tabItem {
                    Label("Footprint", systemImage: "arrow.3.trianglepath")
                }
                .tag(2)
            
            PhotoView(viewModel: PhotoViewModel(cameraService: CameraService(), treeAPIService: TreeAPIService()))
                .tabItem {
                    Label("Add", systemImage: "plus")
                }
                .tag(3)
        }
        .onReceive(quickActionService.$selectedAction) { action in
            guard let action = action else { return }
            switch action {
            case .mapTree:
                selectedTab = 3
            }
        }
    }
}
