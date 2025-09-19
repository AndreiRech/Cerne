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
    @StateObject private var router = Router()

    var body: some View {
        TabView(selection: $router.selectedTab) {
            Tab("Home", systemImage: "arrow.trianglehead.2.clockwise.rotate.90.icloud", value: 0) {
                ContentView()
            }
            
            Tab("Map", systemImage: "map", value: 1) {
                MapView(viewModel: MapViewModel(locationService: LocationService(), pinService: PinService(), userService: UserService(), scannedTreeService: ScannedTreeService()))
            }

            Tab("Footprint", systemImage: "leaf.arrow.trianglehead.clockwise", value: 2) {
                ContentView()
            }

            Tab("Add", systemImage: "plus", value: 3, role: .search) {
                NavigationStack(path: $router.path) {
                    PhotoView(viewModel: PhotoViewModel(cameraService: CameraService(), treeAPIService: TreeAPIService()))
                        .toolbar(.hidden, for: .tabBar)
                }
                .id(router.addFlowID)
            }
        }
        .environmentObject(router)
        .onReceive(quickActionService.$selectedAction) { action in
            guard let action = action else { return }
            switch action {
            case .mapTree:
                router.selectedTab = 3
            }
        }
    }
}
