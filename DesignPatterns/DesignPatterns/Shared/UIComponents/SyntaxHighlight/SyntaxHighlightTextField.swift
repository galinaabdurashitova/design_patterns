//
//  SyntaxHighlightTextView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 02.07.2025.
//

import SwiftUI
import TreeSitterSwiftRunestone
import Runestone

struct SyntaxHighlightTextField: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> TextView {
        let textView = TextView()
        textView.editorDelegate = context.coordinator
        textView.backgroundColor = .systemBackground
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.autocorrectionType = .yes
        textView.autocapitalizationType = .none
        
        updateTextViewState(textView, text: text)
        
        return textView
    }
    
    func updateUIView(_ uiView: TextView, context: Context) {
        guard uiView.text != text else { return }

        uiView.text = text 
        updateTextViewState(uiView, text: text)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func updateTextViewState(_ textView: TextView, text: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let state = TextViewState(text: text, language: .swift)

            DispatchQueue.main.async {
                textView.setState(state)
            }
        }
    }
    
    class Coordinator: NSObject, TextViewDelegate {
        var parent: SyntaxHighlightTextField

        init(_ parent: SyntaxHighlightTextField) {
            self.parent = parent
        }

        func textViewDidChange(_ textView: TextView) {
            parent.text = textView.text
        }
    }
}

#Preview {
    SyntaxHighlightTextField(text: .constant("""
            func textViewDidChange(_ textView: UITextView) {
                parent.text = textView.text
            }
    """))
    .padding()
}
