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
        let request = DesignPatternEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let entity = try coreData.fetchOne(request) else {
            throw DataSourceError.notFound
        }
        return try DesignPatternMapper.from(entity: entity)
    }

    func addPattern(_ pattern: DesignPattern) throws {
        _ = DesignPatternMapper.toEntity(from: pattern, context: coreData.create(DesignPatternEntity.self).managedObjectContext!)
        try coreData.saveIfNeeded()
    }

    func updatePattern(_ id: UUID, pattern: DesignPattern) throws {
        let request = DesignPatternEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let entity = try coreData.fetchOne(request) else {
            throw DataSourceError.notFound
        }
        entity.name = pattern.name
        entity.patternDescription = pattern.patternDescription
        entity.type = pattern.type.rawValue
        try coreData.saveIfNeeded()
    }
}
