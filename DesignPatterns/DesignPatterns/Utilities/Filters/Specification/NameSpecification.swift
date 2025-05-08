//
//  NameSpecification.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

class NameSpecification: Specification {
    typealias T = DesignPattern
    let name: String
    
    init(_ name: String) {
        self.name = name
    }
    
    func isSatisfied(_ item: DesignPattern) -> Bool {
        return item.name.lowercased().contains(name.lowercased())
    }
}
