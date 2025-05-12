//
//  DataSourceProtocol.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 12.05.2025.
//

import Foundation

protocol DataSourceProtocol {
    func getPattern(_ id: UUID) throws -> DesignPattern
    func getPatterns() throws -> [DesignPattern]
    func addPattern(_ pattern: DesignPattern) throws
    func updatePattern(_ id: UUID, pattern: DesignPattern) throws
}
