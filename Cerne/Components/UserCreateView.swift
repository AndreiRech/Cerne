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
    let onTap: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle")
                .resizable()
                .font(.system(size: 200))
                .frame(width: 220, height: 220)
                .fontWeight(.thin)
                .padding(.bottom, 16)
                .foregroundStyle(.primitivePrimary)
                    
            VStack(alignment: .leading, spacing: 10) {
                Text("Defina seu nome de usuário")
                    .foregroundStyle(.primitivePrimary)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                TextField("", text: $username, prompt: Text("@marinacarvalho").foregroundStyle(.primitivePrimary))
                    .padding(20)
                    .frame(height: 62)
                    .background(
                        RoundedRectangle(cornerRadius: 26)
                            .foregroundStyle(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 26)
                                    .stroke(.primitivePrimary, lineWidth: 1)
                            )
                    )
                    .foregroundStyle(.primitivePrimary)
            }
            
            VStack(alignment: .center, spacing: 4) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Qual tua altura?")
                        .foregroundStyle(.primitivePrimary)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    TextField("", text: $height, prompt: Text("1,71 metros").foregroundStyle(.primitivePrimary))
                        .padding(20)
                        .frame(height: 62)
                        .background(
                            RoundedRectangle(cornerRadius: 26)
                                .foregroundStyle(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 26)
                                        .stroke(.primitivePrimary, lineWidth: 1)
                                )
                        )
                        .foregroundStyle(.primitivePrimary)
                        .keyboardType(.decimalPad)
                }
                
                Text("Sua altura é usada para que a câmera calcule, na hora do mapeamento, com mais precisão a altura das árvores")
                    .font(.caption2)
                    .foregroundStyle(.primitivePrimary)
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
        }
        .padding()
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
