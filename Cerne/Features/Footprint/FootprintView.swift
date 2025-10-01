//
//  FootprintView.swift
//  Cerne
//
//  Created by Richard Fagundes Rodrigues on 24/09/25.
//

import SwiftUI

struct FootprintView: View {
    @State var viewModel: FootprintViewModel
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack {
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
                        .background(.backgroundSecondary.opacity(0.6))
                        .border(.backgroundSecondary.opacity(0.2))
                        .cornerRadius(34)
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
                                        .foregroundStyle(viewModel.isAbleToSave ? .CTA : .disabled)
                                )
                                .foregroundStyle(.white)
                        }
                        .disabled(!viewModel.isAbleToSave)
                        .padding()
                    }
                    .background(.backgroundSecondary.opacity(0.6))
                    .border(.backgroundSecondary.opacity(0.2))
                    .cornerRadius(34)
                    .padding(.horizontal, 16)
                    .tag(viewModel.totalPages)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(1...viewModel.totalPages, id: \.self) { index in
                        Capsule()
                            .fill(index == viewModel.currentPage ? Color("Primitive-Primary") : Color.gray.opacity(0.5))
                            .frame(width: index == viewModel.currentPage ? 24 : 8, height: 8)
                    }
                }
                .animation(.easeInOut, value: viewModel.currentPage)
                .padding(.bottom, 20)
            }
            .blur(radius: viewModel.isOverlayVisible ? 1.3 : 0)
            
            if viewModel.isOverlayVisible {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if viewModel.showConludedAlert {
                            dismiss()
                        }
                    }
            }
            
            if viewModel.isOverlayVisible || viewModel.isLoading {
                 Color.black.opacity(0.4)
                     .ignoresSafeArea()
                     .blur(radius: 1.3)
             }
             
             if viewModel.isLoading {
                 ProgressView()
                     .scaleEffect(1.5)
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                        router.popToRoot()
                        router.selectedTab = 0
                    }
                }
                .onTapGesture {
                    router.popToRoot()
                    router.selectedTab = 0
                }
            }
        }
        .task {
            await viewModel.fetchData()
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
        .animation(.easeInOut(duration: 0.2), value: viewModel.isOverlayVisible)
    }
}
