//
//  DesignPattern+Line.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 01.07.2025.
//

import SwiftUI

extension DesignPattern {
    func patternLineView() -> some View {
        HStack(spacing: 12) {
            Text(self.type.emojiIcon)
                .padding(8)
                .background(
                    Circle().fill(self.type.color)
                )
            
            Text(self.name)
                .font(.system(size: 18, weight: .light, design: .rounded))
                .foregroundColor(.black)
                .kerning(-0.4)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.black)
        }
        .padding(8)
        .background(
            Capsule().fill(Color.white.opacity(0.8))
        )
    }
}


#Preview {
    MockDesignPatterns.patterns[0].patternLineView()
        .padding()
}
