//
//  PersistenceController.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 23.06.2025.
//

import Foundation
import CoreData

final class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    var context: NSManagedObjectContext {
        container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: "DesignPatterns")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data stack error: \(error)")
            }
        }
        
        try? preloadData()
    }
    
    func preloadData() throws {
        let request = NSFetchRequest<DesignPatternEntity>(entityName: "DesignPatternEntity")
        let count = try context.count(for: request)
        guard count == 0 else { return }

        for pattern in MockDesignPatterns.patterns {
            let patternEntity = DesignPatternEntity(context: context)
            patternEntity.id = pattern.id
            patternEntity.name = pattern.name
            patternEntity.patternDescription = pattern.patternDescription
            patternEntity.type = pattern.type.rawValue

            for example in MockCodeExamples.codeExamples where example.id == pattern.id {
                let exampleEntity = CodeExampleEntity(context: context)
                exampleEntity.id = example.id
                exampleEntity.code = example.code
                exampleEntity.designPatternRelationship = patternEntity
            }
        }

        try context.save()
    }
}
