//
//  CodeExampleMapper.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 24.06.2025.
//

import Foundation
import CoreData

class CodeExampleMapper {
    static func from(entity: CodeExampleEntity) throws -> CodeExample {
        guard let id = entity.id else { throw CodeExampleError.emptyId }
        guard let code = entity.code else { throw CodeExampleError.emptyCode }
        guard let pattern = entity.designPatternRelationship else { throw CodeExampleError.missingPattern }
        guard let patternId = pattern.id else { throw DesignPatternError.emptyId }
        
        return CodeExample(id: id, patternId: patternId, code: code)
    }
    
    static func toEntity(
        from example: CodeExample,
        designPattern: DesignPatternEntity,
        context: NSManagedObjectContext
    ) -> CodeExampleEntity {
        let entity = CodeExampleEntity(context: context)
        entity.id = example.id
        entity.code = example.code
        entity.designPatternRelationship = designPattern
        return entity
    }
}
