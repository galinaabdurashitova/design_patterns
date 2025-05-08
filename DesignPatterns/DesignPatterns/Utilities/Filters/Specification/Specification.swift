//
//  Specification.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import Foundation

protocol Specification {
    associatedtype T
    func isSatisfied(_ item: T) -> Bool
}
