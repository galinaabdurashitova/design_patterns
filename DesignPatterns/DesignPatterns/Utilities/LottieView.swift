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
    @Binding var isPlaying: Bool
    
    class Coordinator {
        var animationView: LottieAnimationView?

        init() {}
    }

    init(
        animationFileName: String,
        loopMode: LottieLoopMode,
        isPlaying: Binding<Bool> = .constant(true)
    ) {
        self.animationFileName = animationFileName
        self.loopMode = loopMode
        self._isPlaying = isPlaying
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    func makeUIView(context: Context) -> UIView {
        let containerView = UIView(frame: .zero)

        let animationView = LottieAnimationView(name: animationFileName)
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFill
        animationView.translatesAutoresizingMaskIntoConstraints = false

        context.coordinator.animationView = animationView
        containerView.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: containerView.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            animationView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])

        if isPlaying {
            animationView.play()
        }

        return containerView
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let animationView = context.coordinator.animationView else { return }

        if isPlaying {
            if !animationView.isAnimationPlaying {
                animationView.play()
            }
        } else {
            animationView.stop()
        }
    }
}


#Preview {
    LottieView(animationFileName: "pattern_lottie", loopMode: .autoReverse)
        .scaledToFit()
        .frame(width: 200)
}
