//
//  DesignPatternCoreDataDataSource.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 23.06.2025.
//

import Foundation
import CoreData

class DesignPatternCoreDataDataSource: DesignPatternDataSourceProtocol {
    private let container: NSPersistentContainer

    init(container: NSPersistentContainer = PersistenceController.shared.container) {
        self.container = container
    }
    
    func getPattern(_ id: UUID) throws -> DesignPattern {
        let request = DesignPatternEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let entity = try container.viewContext.fetch(request).first else { throw DataSourceError.notFound }
        return try DesignPatternMapper.from(entity: entity)
    }
    
    func getPatterns() throws -> [DesignPattern] {
        let request = DesignPatternEntity.fetchRequest()
        let results = try container.viewContext.fetch(request)
        return results.compactMap { try? DesignPatternMapper.from(entity: $0) }
    }
    
    func addPattern(_ pattern: DesignPattern) throws {
        _ = DesignPatternMapper.toEntity(from: pattern, context: container.viewContext)
        try container.viewContext.save()
    }
    
    func updatePattern(_ id: UUID, pattern: DesignPattern) throws {
        let request = DesignPatternEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1

        guard let entity = try container.viewContext.fetch(request).first else {
            throw DataSourceError.notFound
        }

        entity.name = pattern.name
        entity.patternDescription = pattern.patternDescription
        entity.type = pattern.type.rawValue
        
        try container.viewContext.save()
    }
}
