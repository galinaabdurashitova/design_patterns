//
//  PersistenceController.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 23.06.2025.
//

import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "DesignPatterns")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        preloadData()
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    func preloadData() {
        let request = NSFetchRequest<DesignPatternEntity>(entityName: "DesignPatternEntity")

        if (try? context.count(for: request)) == 0 {
            for pattern in MockDesignPatterns.patterns {
                let newPattern = DesignPatternEntity(context: context)
                newPattern.id = pattern.id
                newPattern.name = pattern.name
                newPattern.type = pattern.type.rawValue
                
                try? context.save()
                
                for codeExample in MockCodeExamples.codeExamples where codeExample.id == pattern.id {
                    let newCodeExample = CodeExampleEntity(context: context)
                    newCodeExample.id = codeExample.id
                    newCodeExample.code = codeExample.code
                    newCodeExample.designPatternRelationship = newPattern
                }
                
                try? context.save()
            }
            
//            do {
//                try context.save()
//            } catch {
//                print(error.localizedDescription)
//            }
        }
    }
}
