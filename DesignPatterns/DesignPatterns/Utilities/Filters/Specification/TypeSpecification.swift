//
//  TypeSpecification.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

class TypeSpecification: Specification {
    typealias T = DesignPattern
    let type: DesignPatternType
    
    init(_ type: DesignPatternType) {
        self.type = type
    }
    
    func isSatisfied(_ item: DesignPattern) -> Bool {
        return item.type == type
    }
}
