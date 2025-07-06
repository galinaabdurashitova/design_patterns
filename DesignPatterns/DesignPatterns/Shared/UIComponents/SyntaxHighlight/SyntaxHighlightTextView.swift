//
//  SyntaxHighlightTextView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 06.07.2025.
//

import SwiftUI
import TreeSitterSwiftRunestone
import Runestone

struct SyntaxHighlightTextView: UIViewRepresentable {
    let text: String

    func makeUIView(context: Context) -> TextView {
        let textView = TextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear

        applyHighlighting(to: textView)
        return textView
    }

    func updateUIView(_ uiView: TextView, context: Context) {
        guard uiView.text != text else { return }

        uiView.text = text
        applyHighlighting(to: uiView)
    }

    // MARK: - Private
    private func applyHighlighting(to textView: TextView) {
        DispatchQueue.global(qos: .userInitiated).async {
            let state = TextViewState(text: text, language: .swift)
            DispatchQueue.main.async { textView.setState(state) }
        }
    }
}

#Preview {
    SyntaxHighlightTextView(text: """
    do {
    } catch {
    }
    """)
    .padding()
}
