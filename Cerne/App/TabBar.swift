//
//  TabBar.swift
//  Cerne
//
//  Created by Andrei Rech on 04/09/25.
//

import SwiftUI

struct TabBar: View {
    @EnvironmentObject var quickActionService: QuickActionService
    @StateObject private var router = Router()
    
    var body: some View {
        TabView(selection: $router.selectedTab) {
            Tab(value: 0) {
                TodayView(viewModel: TodayViewModel(repository: TodayRepository(pinService: PinService(), userService: UserService(), treeService: ScannedTreeService(), footprintService: FootprintService())))
            } label: {
                Label("Hoje", systemImage: "arrow.trianglehead.2.clockwise.rotate.90.icloud")
            }
            
            Tab(value: 1) {
                MapView(
                    viewModel: MapViewModel(
                        locationService: LocationService(),
                        pinService: PinService(),
                        userService: UserService(),
                        scannedTreeService: ScannedTreeService()
                    )
                )
            } label: {
                Label("Mapa", systemImage: "map")
            }
            
            Tab(value: 2, role: .search) {
                NavigationStack(path: $router.path) {
                    PhotoView(
                        viewModel: PhotoViewModel(
                            cameraService: CameraService(),
                            treeAPIService: TreeAPIService(),
                            userDefaultService: UserDefaultService()
                        )
                    )
                    .toolbar(.hidden, for: .tabBar)
                }
                .id(router.addFlowID)
            } label: {
                Label("Add", systemImage: "plus")
            }
        }
        .environmentObject(router)
        .tint(.tabBarAtivada)
        .onReceive(quickActionService.$selectedAction) { action in
            guard let action = action else { return }
            switch action {
            case .mapTree:
                router.selectedTab = 1
            }
        }
    }
}

