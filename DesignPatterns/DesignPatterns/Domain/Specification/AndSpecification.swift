//
//  AndSpecification.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

class AndSpecification<T, SpecA: Specification, SpecB: Specification>: Specification
where SpecA.T == SpecB.T, T == SpecA.T, T == SpecB.T {
    let first: SpecA
    let second: SpecB
    
    init(_ first: SpecA, _ second: SpecB) {
        self.first = first
        self.second = second
    }
    
    func isSatisfied(_ item: T) -> Bool {
        return first.isSatisfied(item) && second.isSatisfied(item)
    }
}
