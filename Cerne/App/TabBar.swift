//
//  TabBar.swift
//  Cerne
//
//  Created by Andrei Rech on 04/09/25.
//

import SwiftUI

struct TabBar: View {
    @EnvironmentObject var quickActionService: QuickActionService
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            
            Tab("Home", systemImage: "house.fill", value: 0) {
                ContentView()
            }
            
            Tab("Map", systemImage: "map.fill", value: 1) {
                ContentView()
            }
            
            Tab("Footprint", systemImage: "arrow.3.trianglepath", value: 2) {
                PhotoView(viewModel: PhotoViewModel(cameraService: CameraService(), treeAPIService: TreeAPIService()))
            }
            
            Tab("Add", systemImage: "plus", value: 3, role: .search) {
                HeightView(viewModel: HeightViewModel(cameraService: CameraService(), motionService: MotionService(), userHeight: 1.85, distanceToTree: 5))
            }
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
