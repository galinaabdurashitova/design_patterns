//
//  CodeExampleCoreDataDataSource.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 24.06.2025.
//

import Foundation
import CoreData

class CodeExampleCoreDataDataSource: CodeExampleDataSourceProtocol {
    private let container: NSPersistentContainer

    init(container: NSPersistentContainer = PersistenceController.shared.container) {
        self.container = container
    }
    
    func getCodeExample(_ id: UUID) throws -> CodeExample {
        let request = CodeExampleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        guard let entity = try container.viewContext.fetch(request).first else { throw DataSourceError.notFound }
        return try CodeExampleMapper.from(entity: entity)
    }
    
    func getCodeExamples(patternId: UUID) throws -> [CodeExample] {
        let request = CodeExampleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "designPatternRelationship.id == %@", patternId as CVarArg)
        let results = try container.viewContext.fetch(request)
        return results.compactMap { try? CodeExampleMapper.from(entity: $0) }
    }
    
    func addCodeExample(_ codeExample: CodeExample) throws {
        let request = DesignPatternEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", codeExample.patternId as CVarArg)
        guard let patternEntity = try container.viewContext.fetch(request).first else { throw CodeExampleError.missingPattern }
        _ = CodeExampleMapper.toEntity(from: codeExample, designPattern: patternEntity, context: container.viewContext)
        try container.viewContext.save()
    }
    
    func updateCodeExample(_ id: UUID, codeExample: CodeExample) async throws {
        let request = CodeExampleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        guard let entity = try container.viewContext.fetch(request).first else { throw DataSourceError.notFound }

        let patternRequest = DesignPatternEntity.fetchRequest()
        patternRequest.predicate = NSPredicate(format: "id == %@", codeExample.patternId as CVarArg)
        guard let patternEntity = try container.viewContext.fetch(patternRequest).first else { throw CodeExampleError.missingPattern }
        
        entity.id = codeExample.id
        entity.code = codeExample.code
        entity.designPatternRelationship = patternEntity
        
        try container.viewContext.save()
    }
}
