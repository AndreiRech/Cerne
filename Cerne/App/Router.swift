//
//  Router.swift
//  Cerne
//
//  Created by Maria Santellano on 17/09/25.
//

import SwiftUI

class Router: ObservableObject {
    @Published var path = NavigationPath()
    @Published var addFlowID = UUID()
    var selectedTab: Int = 0

    func popToRoot() {
        path = NavigationPath()
        addFlowID = UUID()
        selectedTab = 0
    }
}
