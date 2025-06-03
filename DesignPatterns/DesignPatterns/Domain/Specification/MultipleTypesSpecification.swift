//
//  MultipleTypesSpecification.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 03.06.2025.
//

import Foundation

class MultipleTypesSpecification: Specification {
    typealias T = DesignPattern
    let type: [DesignPatternType]
    
    init(_ type: [DesignPatternType]) {
        self.type = type
    }
    
    func isSatisfied(_ item: DesignPattern) -> Bool {
        return type.contains(item.type)
    }
}
