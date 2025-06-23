//
//  DesignPatternView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 01.06.2025.
//

import SwiftUI

struct DesignPatternView: View {    
    let selectedPattern: DesignPattern
    let closeButtonAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                overlayContainer { patternHeader }
                
                Spacer()
                
                closeButton
            }
            
            overlayContainer { patternDescriptionText }
        }
        .shadow(color: selectedPattern.type.backgroundColor, radius: 15)
    }
    
    private var patternHeader: some View {
        HStack(spacing: 8) {
            Text(selectedPattern.name)
                .font(.system(size: 24, weight: .bold, design: .rounded))
            Text(selectedPattern.type.emojiIcon)
        }
    }
    
    private var patternDescriptionText: some View {
        Text(selectedPattern.patternDescription)
            .font(.system(size: 18, weight: .light, design: .rounded))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var closeButton: some View {
        Button(action: closeButtonAction) {
            Image(systemName: "xmark")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
                .padding(12)
                .background(
                    Circle().fill(Color.white.opacity(0.8))
                )
        }
    }
    
    private func overlayContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.8))
            )
    }
}

#Preview {
    DesignPatternView(selectedPattern: MockDesignPatterns.patterns[0]) { }
        .padding()
}
