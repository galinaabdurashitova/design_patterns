//
//  LottieView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 29.06.2025.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var animationFileName: String
    let loopMode: LottieLoopMode

    func makeUIView(context: Context) -> UIView {
        // Create a container UIView
        let containerView = UIView(frame: .zero)

        // Initialize the LottieAnimationView
        let animationView = LottieAnimationView(name: animationFileName)
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFill
        animationView.translatesAutoresizingMaskIntoConstraints = false

        // Add the animationView to the container
        containerView.addSubview(animationView)

        // Set up Auto Layout constraints to make the animation fill the container
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: containerView.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])

        // Start the animation
        animationView.play()

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

#Preview {
    LottieView(animationFileName: "pattern_lottie", loopMode: .autoReverse)
        .scaledToFit()
        .frame(width: 200)
}
