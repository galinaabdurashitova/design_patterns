//
//  DataSourceProtocol.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 12.05.2025.
//

import Foundation

protocol DesignPatternDataSourceProtocol {
    func getPattern(_ id: UUID) async throws -> DesignPattern
    func getPatterns() async throws -> [DesignPattern]
    func addPattern(_ pattern: DesignPattern) async throws
    func updatePattern(_ id: UUID, pattern: DesignPattern) async throws
    func deletePattern(_ id: UUID) async throws
}
