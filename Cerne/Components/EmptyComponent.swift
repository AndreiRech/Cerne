//
//  EmptyComponent.swift
//  Cerne
//
//  Created by Gabriel Kowaleski on 25/09/25.
//

import SwiftUI

struct EmptyComponent: View {
    var bgColor: Color
    var cornerColor: Color
    var icon: String?
    var title: String?
    var subtitle: String
    var description: String
    var buttonTitle: String?
    var buttonAction: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if title != nil {
                HStack(alignment: .center, spacing: 8) {
                    Image(systemName: icon ?? "")
                        .foregroundStyle(.primitivePrimary)
                        .font(.footnote)
                        .fontWeight(.regular)
                    
                    Text(title ?? "")
                        .foregroundStyle(.primitivePrimary)
                        .font(.caption2)
                        .fontWeight(.regular)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(subtitle)
                    .foregroundStyle(.primitivePrimary)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text(description)
                    .foregroundStyle(.primitivePrimary)
                    .font(.footnote)
                    .fontWeight(.regular)
            }
            
            if buttonTitle != nil {
                Button {
                    self.buttonAction?()
                } label: {
                    Text(buttonTitle ?? "")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 1000)
                                .foregroundStyle(.CTA)
                        )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 26)
                .foregroundStyle(bgColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 26)
                        .stroke(cornerColor, lineWidth: 1)
                )
        )
    }
}
