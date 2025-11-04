//
//  UserCreateView.swift
//  Cerne
//
//  Created by Andrei Rech on 25/09/25.
//

import SwiftUI

struct UserCreateView: View {
    @Binding var username: String
    @Binding var height: String
    @Binding var usernameError: Bool
    @Binding var heightError: Bool
    @Binding var heightErrorMessage: String
    
    let onTap: () -> Void
    
    @State private var oldHeight: String = ""
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .resizable()
                .font(.system(size: 200))
                .frame(width: 220, height: 220)
                .fontWeight(.thin)
                .padding(.bottom, 16)
                .foregroundStyle(.primitivePrimary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Defina seu nome de usuário")
                    .foregroundStyle(.primitivePrimary)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.bottom, 6)
                
                TextField("", text: $username, prompt: Text("@marinacarvalho").foregroundStyle(.primitivePrimary.opacity(0.6)))
                    .padding(20)
                    .frame(height: 62)
                    .background(
                        RoundedRectangle(cornerRadius: 26)
                            .foregroundStyle(.backgroundPrimary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 26)
                                    .stroke(usernameError ? .red : .primitivePrimary, lineWidth: 1)
                            )
                    )
                    .foregroundStyle(.primitivePrimary)
                
                if usernameError {
                    Text("Nome de usuário não pode estar vazio.")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .padding(.leading, 10)
                        .transition(.opacity.combined(with: .slide))
                }
            }
            .padding(.bottom, 10)
            
            VStack(alignment: .center, spacing: 4) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Qual tua altura?")
                        .foregroundStyle(.primitivePrimary)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.bottom, 6)
                    
                    TextField("", text: $height, prompt: Text("1,71 metros").foregroundStyle(.primitivePrimary.opacity(0.6)))
                        .padding(20)
                        .frame(height: 62)
                        .background(
                            RoundedRectangle(cornerRadius: 26)
                                .foregroundStyle(.backgroundPrimary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 26)
                                        .stroke(heightError ? .red : .primitivePrimary, lineWidth: 1)
                                )
                        )
                        .foregroundStyle(.primitivePrimary)
                        .keyboardType(.decimalPad)
                        .onChange(of: height) { _, newValue in
                            if newValue.count > oldHeight.count {
                                if newValue.count == 1 && Int(newValue) != nil {
                                    height = newValue + ","
                                }
                            }
                            oldHeight = height
                        }
                        .onAppear {
                            oldHeight = height
                        }
                    
                    if heightError {
                        Text(heightErrorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.leading, 10)
                            .transition(.opacity.combined(with: .slide))
                    }
                }
                
                Text("Sua altura é usada para que a câmera calcule, na hora do mapeamento, com mais precisão a altura das árvores")
                    .font(.caption2)
                    .foregroundStyle(.primitivePrimary)
                    .padding(.top, heightError ? 0 : 4)
            }
            
            Button {
                onTap()
            } label: {
                Text("Salvar")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(
                        RoundedRectangle(cornerRadius: 10000)
                            .foregroundStyle(.CTA)
                    )
                    .glassEffect()
                    .foregroundStyle(.white)
            }
            .padding(.top)
        }
        .padding()
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .animation(.easeInOut, value: usernameError)
        .animation(.easeInOut, value: heightError)
    }
}
