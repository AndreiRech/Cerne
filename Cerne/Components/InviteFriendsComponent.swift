//
//  InviteFriendsComponent.swift
//  Cerne
//
//  Created by Maria Santellano on 24/09/25.
//

import SwiftUI

struct InviteFriendsComponent: View {
    var shareAction: () -> Void

    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "person.badge.plus")
                    .foregroundStyle(.primitivePrimary)
                    .font(.footnote)
                    .fontWeight(.regular)
                
                Text("Mais pessoas, mais impacto")
            }
            .font(.caption2)
            (
                Text("Compartilhe o App e \(Text("ajude a aumentar o mapeamento").fontWeight(.semibold)) de zonas com maior potencial de sequestro de CO²")
            )
            .font(.body)
            
            Button {
                self.shareAction()
            } label: {
                Text("Convidar amigos")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .foregroundStyle(.CTA)
                    )
            }
        }
        .padding(20)
        .background(.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 26))
    }
}

