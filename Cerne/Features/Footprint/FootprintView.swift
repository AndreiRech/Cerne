//
//  FootprintView.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 24/09/25.
//

import SwiftUI

struct FootprintView: View {
    @State var viewModel: FootprintViewModelProtocol
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.white, .blue]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                // TODO: Desenhar a Sheet da tela.
            }
        }
    }
}

#Preview {
    FootprintView(viewModel: FootprintViewModel())
}
