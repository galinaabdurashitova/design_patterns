//
//  BackgroundGradient.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 01.06.2025.
//

import SwiftUI

struct BackgroundGradient: View {
    var body: some View {
        LinearGradient(
            colors: [
                .blueBackground,
                .yellowBackground,
                .pinkBackground
            ],
            startPoint: UnitPoint(x: 0, y: 1),
            endPoint: UnitPoint(x: 1, y: 0)
        )
        .ignoresSafeArea()
    }
}

#Preview {
    BackgroundGradient()
}
