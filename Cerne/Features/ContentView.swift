//
//  ContentView.swift
//  Cerne
//
//  Created by Andrei Rech on 03/09/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        CommunityDataComponent(infoType: .trees, icon: .treeIcon, title: "12.500 árvores")
        ContribuitionTreeComponent(treeName: "Ipe-Amarelo", treeCO2: 1002, treeImage: .arvoreamarela)
    }
}
