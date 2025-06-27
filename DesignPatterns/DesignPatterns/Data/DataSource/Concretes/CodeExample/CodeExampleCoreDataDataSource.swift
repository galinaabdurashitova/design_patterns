//
//  CodeExampleCoreDataDataSource.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 24.06.2025.
//

import Foundation
import CoreData

class CodeExampleCoreDataDataSource: CodeExampleDataSourceProtocol {
    private let coreData: CoreDataServiceProtocol

    init(coreData: CoreDataServiceProtocol = CoreDataService()) {
        self.coreData = coreData
    }
    
    func getCodeExample(_ id: UUID) throws -> CodeExample {
        let request = CodeExampleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let entity = try coreData.fetchOne(request) else {
            throw DataSourceError.notFound
        }
        return try CodeExampleMapper.from(entity: entity)
    }
    
    func getCodeExamples(patternId: UUID) throws -> [CodeExample] {
        let request = CodeExampleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "designPatternRelationship.id == %@", patternId as CVarArg)
        return try coreData.fetch(request).compactMap {
            try? CodeExampleMapper.from(entity: $0)
        }
    }
    
    func addCodeExample(_ codeExample: CodeExample) throws {
        let request = DesignPatternEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", codeExample.patternId as CVarArg)
        guard let patternEntity = try coreData.fetchOne(request) else {
            throw CodeExampleError.missingPattern
        }
        
        _ = CodeExampleMapper.toEntity(
            from: codeExample,
            designPattern: patternEntity,
            context: coreData.create(DesignPatternEntity.self).managedObjectContext!
        )
        try coreData.saveIfNeeded()
    }
    
    func updateCodeExample(_ id: UUID, codeExample: CodeExample) async throws {
        let request = CodeExampleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let entity = try coreData.fetchOne(request) else {
            throw DataSourceError.notFound
        }

        let patternRequest = DesignPatternEntity.fetchRequest()
        patternRequest.predicate = NSPredicate(format: "id == %@", codeExample.patternId as CVarArg)
        guard let patternEntity = try coreData.fetchOne(patternRequest) else {
            throw CodeExampleError.missingPattern
        }

        entity.id = codeExample.id
        entity.code = codeExample.code
        entity.designPatternRelationship = patternEntity

        try coreData.saveIfNeeded()
    }
}
