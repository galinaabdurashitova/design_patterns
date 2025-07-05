//
//  MainButtonView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 01.07.2025.
//

import SwiftUI

struct MainButtonView<Content: View>: View {
    @Binding var isDisabled: Bool
    let colour: Color
    let action: () -> Void
    let content: () -> Content
    
    init(
        isDisabled: Binding<Bool> = .constant(false),
        colour: Color = .blueAccent,
        action: @escaping () -> Void,
        content: @escaping () -> Content
    ) {
        self._isDisabled = isDisabled
        self.colour = colour
        self.action = action
        self.content = content
    }
    
    var body: some View {
        Button(action: action) {
            content()
                .foregroundColor(isDisabled ? Color(.systemGray3) : .primary)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(colour)
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
