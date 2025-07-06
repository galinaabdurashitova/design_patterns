//
//  GrayButton.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 06.07.2025.
//

import SwiftUI

struct GrayButton<Content: View>: View {
    let action: () -> Void
    let content: () -> Content
    
    var body: some View {
        Button(action: action) {
            content()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
        }
    }
}

#Preview {
    GrayButton { } content: { Text("Button") }
}
