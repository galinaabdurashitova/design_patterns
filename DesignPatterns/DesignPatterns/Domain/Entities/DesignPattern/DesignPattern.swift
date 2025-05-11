//
//  DesignPattern.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

struct DesignPattern: Identifiable {
    var id: UUID = UUID()
    var name: String
    var type: DesignPatternType
    var description: String
}
