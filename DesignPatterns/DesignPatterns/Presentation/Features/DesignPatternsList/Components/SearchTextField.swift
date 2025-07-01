//
//  SearchTextField.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 03.06.2025.
//

import SwiftUI

struct SearchTextField: View {
    @Binding var searchText: String
    let searchHint: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .opacity(0.6)
            
            TextField(searchHint, text: $searchText)
                .accessibilityIdentifier("searchTextField")
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black.opacity(0.6))
                }
                .accessibilityIdentifier("searchClearButton")
            }
        }
        .filterFieldStyle(cornerRadius: 12)
    }
}

#Preview {
    SearchTextField(searchText: .constant(""), searchHint: "Search")
        .padding()
}
