//
//  ContentView.swift
//  Cerne
//
//  Created by Andrei Rech on 03/09/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var isShowingDetails: Bool = false
        
    let samplePin: Pin = {
        let user = User(name: "Marina Carvalho", height: 1.65)
        let tree = ScannedTree(species: "Ipê-amarelo", height: 15.0, dap: 0.8, totalCO2: 668)
        return Pin(latitude: 0, longitude: 0, date: Date(), user: user, tree: tree)
    }()

    var body: some View {
        ZStack {
            Image(.treeDefault)
            
            Button {
                isShowingDetails.toggle()
            } label: {
                Text("Show details")
            }
        }
        
        .navigationTitle("Cerne")
        .sheet(isPresented: $isShowingDetails) {
            ScrollView{
                PinDetailsView(pin: samplePin)
                    .presentationDetents([.height(265), .height(475)])
                    .presentationDragIndicator(.visible)
            }
            .scrollDisabled(true)
        }
    }
}

#Preview {
    ContentView()
}
