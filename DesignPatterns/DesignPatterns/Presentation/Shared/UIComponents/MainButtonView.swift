//
//  MainButtonView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 01.07.2025.
//

import SwiftUI

struct MainButtonView<Content: View>: View {
    @Binding var isDisabled: Bool
    let action: () -> Void
    let content: () -> Content
    
    var body: some View {
        Button(action: action) {
            content()
                .foregroundColor(isDisabled ? Color(.systemGray3) : .primary)
                .padding(.vertical, 16)
                .padding(.horizontal, 100)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.blueAccent)
                        .opacity(isDisabled ? 0.4 : 1)
                )
        }
        .disabled(isDisabled)
    }
}

#Preview {
    MainButtonView(
        isDisabled: .constant(false),
        action: { },
        content: { Text("Button") }
    )
}
