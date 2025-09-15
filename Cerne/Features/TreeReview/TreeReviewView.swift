// TreeReviewView.swift

import SwiftUI

struct TreeReviewView: View {
    @State var viewModel: TreeReviewViewModel
    @State private var isEditing = false
    
    var body: some View {
        Form {
            Section(header: Text("Revisar Árvore")) {
                if viewModel.isLoading {
                    ProgressView("Processando...")
                } else if let tree = viewModel.tree {
                    if isEditing {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Espécie")
                            TextField("Espécie", text: $viewModel.updateSpecies)
                                .textFieldStyle(.roundedBorder)
                            
                            HStack {
                                Text("Altura:")
                                TextField("Altura", value: $viewModel.updateHeight, format: .number)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.roundedBorder)
                            }
                            HStack {
                                Text("DAP:")
                                TextField("DAP", value: $viewModel.updateDap, format: .number)
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Espécie: \(tree.species)")
                            Text("Altura: \(tree.height, specifier: "%.2f") m")
                            Text("DAP: \(tree.dap, specifier: "%.2f") cm")
                            Text("CO2 Total: \(tree.totalCO2, specifier: "%.2f") kg")
                        }
                    }
                } else {
                    Text("Nenhuma árvore para revisar. Toque em 'Criar' para começar.")
                }
            }
            
            Section {
                if viewModel.isLoading {
                } else if isEditing {
                    Button("Salvar Alterações") {
                        Task {
                            await viewModel.updateScannedTree()
                            if viewModel.errorMessage == nil {
                                isEditing = false
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Cancelar", role: .destructive) {
                        if let tree = viewModel.tree {
                            viewModel.updateSpecies = tree.species
                            viewModel.updateHeight = tree.height
                            viewModel.updateDap = tree.dap
                        }
                        isEditing = false
                    }
                } else {
                    Button("Criar Nova Árvore") {
                        Task {
                            await viewModel.createScannedTree()
                            if let tree = viewModel.tree {
                                viewModel.updateSpecies = tree.species
                                viewModel.updateHeight = tree.height
                                viewModel.updateDap = tree.dap
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)

                    if viewModel.tree != nil {
                        Button("Editar") {
                            isEditing = true
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
        }
        .navigationTitle("Revisão da Árvore")
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
    }
}
