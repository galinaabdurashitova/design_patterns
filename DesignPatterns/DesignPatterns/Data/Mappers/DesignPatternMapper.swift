//
//  DesignPatternMapper.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 23.06.2025.
//

import Foundation
import CoreData

class DesignPatternMapper {
    static func from(entity: DesignPatternEntity) throws -> DesignPattern {
        guard let id = entity.id else { throw DesignPatternError.emptyId }
        guard let name = entity.name else { throw DesignPatternError.emptyName }
        guard let type = DesignPatternType(rawValue: entity.type ?? "") else { throw DesignPatternError.invalidType }
        guard let description = entity.patternDescription else { throw DesignPatternError.emptyDescrition }
        
        return DesignPattern(
            id: id,
            name: name,
            type: type,
            patternDescription: description
        )
    }
    
    static func toEntity(from pattern: DesignPattern, context: NSManagedObjectContext) -> DesignPatternEntity {
        let entity = DesignPatternEntity(context: context)
        entity.id = pattern.id
        entity.name = pattern.name
        entity.type = pattern.type.rawValue
        entity.patternDescription = pattern.patternDescription
        return entity
    }
}
