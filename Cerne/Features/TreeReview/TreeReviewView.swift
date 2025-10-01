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
        if viewModel.showValidation {
            ValidationView(viewModel: ValidationViewModel(tree: viewModel.tree))
        } else {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(width: 60, height: 60)
                    .glassEffect()
            } else {
                VStack {
                    VStack(spacing: 16) {
                        Text("Revise os dados coletados")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primitivePrimary)
                            .padding(.horizontal, 25)
                        
                        Text("Verifique se as informações estão corretas e faça ajustes se necessário. Depois salve para concluir.")
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.primitivePrimary)
                            .padding(.horizontal, 25)
                        
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
                        .padding(.horizontal, 25)
                        
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
                            viewModel.showValidation = true
                        } label: {
                            HStack {
                                Image(systemName: "checkmark")
                                Text("Salvar")
                            }
                            .frame(maxWidth: .infinity)
                            .contentShape(.rect)
                        }
                        .padding(.vertical, 14)
                        .disabled(viewModel.isEditing)
                        .foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(viewModel.isEditing ? .disabled : .CTA)
                        )
                    }
                    .padding(25)
                    .glassEffect(in: .rect(cornerRadius: 26))
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
        }
    }
}
