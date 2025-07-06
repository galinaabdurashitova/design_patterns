//
//  CoreDataService.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 25.06.2025.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    var context: NSManagedObjectContext { get }
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> [T]
    func fetchOne<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> T?
    func saveIfNeeded() throws
    func create<T: NSManagedObject>(_ type: T.Type) -> T
    func delete<T: NSManagedObject>(_ object: T) throws
}

class CoreDataService: CoreDataServiceProtocol {
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }

    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> [T] {
        try context.performAndWait { try context.fetch(request) }
    }

    func fetchOne<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> T? {
        try context.performAndWait {
            request.fetchLimit = 1
            return try context.fetch(request).first
        }
    }

    func saveIfNeeded() throws {
        try context.performAndWait {
            if context.hasChanges {
                try context.save()
            }
        }
    }

    func create<T: NSManagedObject>(_ type: T.Type) -> T {
        context.performAndWait {
            T(context: context)
        }
    }

    func delete<T: NSManagedObject>(_ object: T) throws {
        try context.performAndWait {
            context.delete(object)
            try saveIfNeeded()
        }
    }
}
