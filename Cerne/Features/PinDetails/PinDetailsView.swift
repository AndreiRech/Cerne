//
//  PinDetailsView.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 10/09/25.
//

import SwiftUI

struct PinDetailsView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var viewModel: PinDetailsViewModelProtocol
    
    @State private var isShowingShareSheet = false
    @State private var isShowingDeleteAlert = false
    @State private var isShowingReportAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack() {
                        Button {
                            self.isShowingShareSheet = true
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundStyle(.gray)
                                .font(.system(size: 17, weight: .medium, design: .default))
                                .frame(width: 44, height: 44, alignment: .center)
                                .background(.thickMaterial, in: Circle())
                        }
                        
                        Spacer()
                        
                        Text(viewModel.pin.tree?.species ?? "")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.gray)
                                .font(.system(size: 17, weight: .medium, design: .default))
                                .frame(width: 44, height: 44, alignment: .center)
                                .padding(.vertical, 4)
                                .background(.thickMaterial, in: Circle())
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top)
                    
                    HStack(alignment: .top, spacing: 10) {
                        Image(uiImage: UIImage(data: viewModel.pin.image) ?? UIImage(named: "placeholder")!)
                            .resizable()
                            .frame(width: 102, height: 137, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Sobre a árvore")
                                .font(.body)
                                .fontWeight(.semibold)
                            
                            Text(viewModel.details?.description ?? "")
                                .font(.footnote)
                                .fontWeight(.regular)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .top, spacing: 10){
                        Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.icloud")
                            .foregroundStyle(.primary)
                            .font(.system(size: 17, weight: .semibold, design: .default))
                            .frame(width: 26, height: 26, alignment: .center)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(viewModel.pin.formattedTotalCO2) kg de CO² capturado")
                                .font(.body)
                                .fontWeight(.semibold)
                            
                            Text("Aproximadamente")
                                .font(.footnote)
                                .fontWeight(.regular)
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 10){
                        Image(systemName: "leaf.arrow.trianglehead.clockwise")
                            .foregroundStyle(.primary)
                            .font(.system(size: 17, weight: .semibold, design: .default))
                            .frame(width: 26, height: 26, alignment: .center)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Comparativo")
                                .font(.body)
                                .fontWeight(.semibold)
                            
                            Text("A captura dessa árvore equivale a emissão de um carro, movido a gasolina, rodando 2.890 km")
                                .font(.footnote)
                                .fontWeight(.regular)
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 10){
                        Image(systemName: "calendar.badge.checkmark")
                            .foregroundStyle(.primary)
                            .font(.system(size: 17, weight: .semibold, design: .default))
                            .frame(width: 26, height: 26, alignment: .center)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(viewModel.pin.formattedDate)")
                                .font(.body)
                                .fontWeight(.semibold)
                            
                            Text("Data de registro no Cerne")
                                .font(.footnote)
                                .fontWeight(.regular)
                        }
                    }
                    
                    HStack(alignment: .top, spacing: 10){
                        Image(systemName: "person.icloud.fill")
                            .foregroundStyle(.primary)
                            .font(.system(size: 17, weight: .semibold, design: .default))
                            .frame(width: 26, height: 26, alignment: .center)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(viewModel.pin.user?.name ?? "Nome do usuário não disponível")")
                                .font(.body)
                                .fontWeight(.semibold)
                            
                            Text("Usuário responsável pelo mapeamento")
                                .font(.footnote)
                                .fontWeight(.regular)
                        }
                    }
                }
                
                Button {
                    if viewModel.isPinFromUser() {
                        isShowingDeleteAlert = true
                    } else {
                        isShowingReportAlert = true
                    }
                } label: {
                    HStack {
                        Image(systemName: viewModel.isPinFromUser() ? "trash" : "exclamationmark.bubble")
                        Text(viewModel.isPinFromUser() ? "Deletar Árvore" : "Relatar um Problema")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .foregroundStyle(viewModel.isPinFromUser() ? .red : .primary)
                    .background(
                        RoundedRectangle(cornerRadius: 1000)
                            .foregroundStyle(viewModel.isPinFromUser() ? Color.red.opacity(0.2) : .secondary.opacity(0.2))
                    )
                }
            }
            .padding(.horizontal, 23)
        }
        .scrollDisabled(true)
        .sheet(isPresented: $isShowingShareSheet) {
            ShareSheet(items: ["Vem mapear árvores!"])
        }
        .alert("Deletar Registro", isPresented: $isShowingDeleteAlert) {
            Button("Cancelar", role: .cancel) {
                dismiss()
            }
            Button("Deletar", role: .destructive) {
                viewModel.deletePin(pin: viewModel.pin)
                dismiss()
                
            }
        } message: {
            Text("Este registro será removido e não poderá ser recuperado.")
        }
        
        .alert("Denunciar Registro", isPresented: $isShowingReportAlert) {
            Button("Cancelar", role: .cancel) {
                dismiss()
            }
            Button("Denunciar", role: .destructive) {
                viewModel.reportPin(to: viewModel.pin)
                dismiss()
            }
        } message: {
            Text("Registro duplicado, incorreto ou não deveria estar no Aplicativo.")
        }
    }
}
