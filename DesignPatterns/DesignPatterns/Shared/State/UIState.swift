//
//  UIState.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 28.05.2025.
//

import Foundation

/// A generic state container for handling async UI loading states.
enum UIState<T> {
    case idle       // No action has been taken yet
    case loading    // Currently loading
    case error(Error) // Loading failed with an error
    case success(T) // Successfully loaded with result
}
