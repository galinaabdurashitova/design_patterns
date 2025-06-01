//
//  DesignPatternFilter.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

class DesignPatternFilter: FilterProtocol {
    typealias T = DesignPattern
    
    func filter<Spec: Specification>(items: [DesignPattern], with specification: Spec) -> [T] where Spec.T == T {
        let result = items.filter {
            specification.isSatisfied($0)
        }
        
        return result
    }
}
