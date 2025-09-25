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
            Image(systemName: "v.circle.fill")
                .resizable()
                .font(.system(size: 60))
                .foregroundColor(Color.blue)
                .padding(.bottom, 40)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Defina seu nome de usuário")
                    .fontWeight(.semibold)
                    .foregroundStyle(.primitive2)
                
                TextField("", text: $username, prompt: Text("@mariacarvalho").foregroundStyle(.labelSecondary))
                    .padding(20)
                    .frame(height: 62)
                    .background(
                        RoundedRectangle(cornerRadius: 26)
                            .foregroundStyle(.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 26)
                                    .stroke(.labelPrimary, lineWidth: 1)
                            )
                    )
                    .foregroundStyle(.labelPrimary)
            }
            
            VStack(alignment: .center, spacing: 4) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Qual tua altura?")
                        .fontWeight(.semibold)
                        .foregroundStyle(.primitive2)
                    
                    TextField("", text: $height, prompt: Text("1,71 metros").foregroundStyle(.labelSecondary))
                        .padding(20)
                        .frame(height: 62)
                        .background(
                            RoundedRectangle(cornerRadius: 26)
                                .foregroundStyle(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 26)
                                        .stroke(.labelPrimary, lineWidth: 1)
                                )
                        )
                        .foregroundStyle(.labelPrimary)
                        .keyboardType(.decimalPad)
                }
                
                Text("Sua altura é usada para que a câmera calcule, na hora do mapeamento, com mais precisão a altura das árvores.")
                    .font(.caption2)
                    .foregroundStyle(.labelPrimary)
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
                            .foregroundStyle(.primitive1)
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
