//
//  ErrorView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 03.06.2025.
//

import SwiftUI

struct ErrorView: View {
    let errorDescription: String
    let reloaadAction: () -> Void
    
    var body: some View {
        VStack {
            Text(errorDescription)
                .opacity(0.6)
                .multilineTextAlignment(.center)
            
            Button(action: reloaadAction) {
                Text("Try again")
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.gray)
                    )
            }
        }
        .padding()
    }
}

#Preview {
    ErrorView(errorDescription: "Some error", reloaadAction: { })
}
