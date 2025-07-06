//
//  DesignPatternCoreDataDataSource.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 23.06.2025.
//

import Foundation
import CoreData

class DesignPatternCoreDataDataSource: DesignPatternDataSourceProtocol {
    private let coreData: CoreDataServiceProtocol

    init(coreData: CoreDataServiceProtocol = CoreDataService()) {
        self.coreData = coreData
    }

    func getPatterns() throws -> [DesignPattern] {
        let request = DesignPatternEntity.fetchRequest()
        return try coreData.fetch(request).compactMap {
            try? DesignPatternMapper.from(entity: $0)
        }
    }

    func getPattern(_ id: UUID) throws -> DesignPattern {
        let entity = try fetchDesignPatternEntity(with: id)
        return try DesignPatternMapper.from(entity: entity)
    }

    func addPattern(_ pattern: DesignPattern) throws {
        _ = DesignPatternMapper.toEntity(from: pattern, context: coreData.context)
        try coreData.saveIfNeeded()
    }

    func updatePattern(_ id: UUID, pattern: DesignPattern) throws {
        let entity = try fetchDesignPatternEntity(with: id)
        entity.name = pattern.name
        entity.patternDescription = pattern.patternDescription
        entity.type = pattern.type.rawValue
        try coreData.saveIfNeeded()
    }
    
    func deletePattern(_ id: UUID) throws {
        let entity = try fetchDesignPatternEntity(with: id)
        try coreData.delete(entity)
    }
    
    // MARK: - Private functions
    
    private func fetchDesignPatternEntity(with id: UUID) throws -> DesignPatternEntity {
        let patternRequest = DesignPatternEntity.fetchRequest()
        patternRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let patternEntity = try coreData.fetchOne(patternRequest) else {
            throw DataSourceError.notFound
        }
        return patternEntity
    }
}
