//
//  FilterProtocol.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

protocol FilterProtocol {
    associatedtype T
    func filter<Spec: Specification>(items: [T], with specification: Spec) -> [T] where Spec.T == T
}
