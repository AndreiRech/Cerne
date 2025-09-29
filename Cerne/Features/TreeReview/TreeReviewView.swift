//
// TreeReviewView.swift
//  Cerne
//
//  Created by Maria Santellano on 10/09/25.
//


import SwiftUI

struct TreeReviewView: View {
    @State var viewModel: TreeReviewViewModel
    @EnvironmentObject var router: Router
    
    
    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(width: 60, height: 60)
                    .glassEffect()
            } else {
                Text("Revise os dados coletados")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primitivePrimary)
                Text("Verifique se as informações estão corretas e faça ajustes se necessário. Depois salve para concluir.")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primitivePrimary)
                    .padding(.horizontal)
                
                VStack(spacing: 10) {
                    TreeInfoComponent(
                        title: viewModel.tree?.species ?? "",
                        subtitle: "Espécie identificada",
                        value: $viewModel.updateSpecies,
                        isEditing: $viewModel.isEditing
                    )
                    NumericInfoComponent(
                        title: String(format: "%.2f m", viewModel.tree?.dap ?? 0.0),
                        subtitle: "Diâmetro do tronco",
                        isHeight: false,
                        value: $viewModel.updateDap,
                        isEditing: $viewModel.isEditing
                    )
                    NumericInfoComponent(
                        title: String(format: "%.2f m", viewModel.tree?.height ?? 0.0),
                        subtitle: "Altura aproximada",
                        isHeight: true,
                        value: $viewModel.updateHeight,
                        isEditing: $viewModel.isEditing
                        
                    )
                    
                }
                .padding()
                
                Button {
                    if viewModel.isEditing {
                        Task {
                            await viewModel.updateScannedTree()
                            viewModel.isEditing = false
                        }
                    } else {
                        viewModel.isEditing = true
                    }
                } label: {
                    HStack {
                        Image(systemName: viewModel.isEditing ? "text.badge.checkmark" : "pencil")
                        Text(viewModel.isEditing ? "Concluir edição" : "Ajustar")
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(.rect)
                }
                .padding(.vertical, 14)
                .foregroundStyle(.black)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(.fillsTertiary)
                )
                
                
                Button {
                    router.popToRoot()
                    router.selectedTab = 1
                    
                } label: {
                    HStack{
                        Image(systemName: "checkmark")
                        Text("Salvar")
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(.rect)
                }
                .disabled(viewModel.isEditing)
                .padding(.vertical, 14)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(viewModel.isEditing ? .primitiveDisabled : .primitivePrimary )
                )
            }
        }
        .padding(.horizontal, 23)
        .padding(.vertical, 25)
        .glassEffect(in: .rect(cornerRadius: 16))
        
        .onAppear {
            if viewModel.tree == nil {
                Task {
                    await viewModel.createScannedTree()
                    if let tree = viewModel.tree {
                        viewModel.updateSpecies = tree.species
                        viewModel.updateHeight = tree.height
                        viewModel.updateDap = tree.dap
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    viewModel.cancel()
                    router.popToRoot()
                    router.selectedTab = 1
                } label: {
                    Image(systemName: "xmark")
                }
                
            }
        }
    }
    
}

