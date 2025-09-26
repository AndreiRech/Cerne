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
            Tab(value: 0) {
                TodayView(viewModel: TodayViewModel(pinService: PinService(), userService: UserService(), footprintService: FootprintService()))
            } label: {
                Label("Hoje", systemImage: "arrow.trianglehead.2.clockwise.rotate.90.icloud")
                    .foregroundStyle(router.selectedTab == 0 ? .tabBarAtivada : .tabBarDesativada)
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
                    .foregroundStyle(router.selectedTab == 1 ? .tabBarAtivada : .tabBarDesativada)
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
                    .foregroundStyle(router.selectedTab == 2 ? .tabBarAtivada : .tabBarDesativada)
            }
        }
        .environmentObject(router)
        .onReceive(quickActionService.$selectedAction) { action in
            guard let action = action else { return }
            switch action {
            case .mapTree:
                router.selectedTab = 1
            }
        }
    }
}

