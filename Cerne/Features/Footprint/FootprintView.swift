//
//  FootprintView.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 24/09/25.
//

import SwiftUI

struct FootprintView: View {
    @State var viewModel: FootprintViewModel
    @Environment(\.dismiss) var dismiss
    
    private var isOverlayVisible: Bool {
        viewModel.showDiscardAlert || viewModel.showConludedAlert
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $viewModel.currentPage) {
                
                ForEach(1...viewModel.totalQuestionPages, id: \.self) { page in
                    CarbonSheet(
                        page: page,
                        isEnabled: true,
                        selections: viewModel.selections,
                        emitters: viewModel.emittersForPage(page),
                        onUpdate: { emitter, newValue in
                            viewModel.updateSelection(for: emitter, to: newValue)
                        }
                    )
                    .glassEffect(in: .rect(cornerRadius: 26))
                    .padding(.horizontal, 16)
                    .tag(page)
                }
                
                VStack {
                    CarbonSheet(
                        page: viewModel.totalPages,
                        isEnabled: false,
                        selections: viewModel.selections,
                        emitters: CarbonEmittersEnum.allCases,
                        onUpdate: { emitter, newValue in
                            viewModel.updateSelection(for: emitter, to: newValue)
                        }
                    )
                    
                    Button {
                        Task {
                            await viewModel.saveFootprint()
                        }
                    } label: {
                        Text("Salvar")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(
                                RoundedRectangle(cornerRadius: 1000)
                                    .foregroundStyle(viewModel.isAbleToSave ? .primitivePrimary : .primitiveDisabled)
                            )
                            .foregroundStyle(.white)
                    }
                    .disabled(!viewModel.isAbleToSave)
                    .padding()
                }
                .glassEffect(in: .rect(cornerRadius: 26))
                .padding(.horizontal, 16)
                .tag(viewModel.totalPages)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .blur(radius: isOverlayVisible ? 1.3 : 0)
            
            if isOverlayVisible {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if viewModel.showConludedAlert {
                            dismiss()
                        }
                    }
            }
            
            if viewModel.showDiscardAlert {
                AlertView(
                    title: "Descartar os dados?",
                    message: "Se fechar agora, as respostas inseridas serão perdidas",
                    onConfirm: {
                        withAnimation {
                            viewModel.showDiscardAlert = false
                        }
                        viewModel.resetSelections()
                        dismiss()
                    },
                    onCancel: {
                        withAnimation {
                            viewModel.showDiscardAlert = false
                        }
                    }
                )
                .padding(.horizontal, 46)
            }
            
            if viewModel.showConludedAlert {
                RegisterConcluded(
                    title: "Registro concluído!",
                    message: "Pegada de carbono calculada com sucesso!"
                )
                .padding(.horizontal, 46)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        dismiss()
                    }
                }
                .onTapGesture {
                    dismiss()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.showDiscardAlert = true
                }) {
                    Image(systemName: "xmark")
                        .font(.headline)
                }
                .disabled(viewModel.showConludedAlert)
            }
        }
        .ignoresSafeArea()
        .background(.backgroundPrimary)
        .animation(.easeInOut(duration: 0.2), value: isOverlayVisible)
    }
}
