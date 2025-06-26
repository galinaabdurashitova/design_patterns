//
//  MockTestDesignPatterns.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 26.06.2025.
//

import Foundation
@testable import DesignPatterns

enum MockTestDesignPatterns {
    static var patterns: [DesignPattern] = [
        DesignPattern(
            name: "Specification",
            type: .behavioral,
            patternDescription: "The Specification pattern encapsulates business rules into reusable and combinable components. It allows you to define complex filtering logic without hardcoding it throughout the application. Specifications can be composed using logical operations like AND, OR, and NOT."
        ),
        DesignPattern(
            name: "Builder",
            type: .creational,
            patternDescription: "The Builder pattern separates the construction of a complex object from its representation. It provides a step-by-step approach to object creation, allowing different representations of the same type to be built with the same construction process."
        ),
        DesignPattern(
            name: "Abstract Factory",
            type: .creational,
            patternDescription: "The Abstract Factory pattern provides an interface for creating families of related or dependent objects without specifying their concrete classes. It ensures consistency among products and promotes flexibility when changing object families."
        )
    ]
}
