//
//  CoreDataService.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 25.06.2025.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> [T]
    func fetchOne<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> T?
    func saveIfNeeded() throws
    func create<T: NSManagedObject>(_ type: T.Type) -> T
    func delete<T: NSManagedObject>(_ object: T) throws
}

class CoreDataService: CoreDataServiceProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.context) {
        self.context = context
    }

    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> [T] {
        try context.fetch(request)
    }

    func fetchOne<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> T? {
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    func saveIfNeeded() throws {
        if context.hasChanges {
            try context.save()
        }
    }

    func create<T: NSManagedObject>(_ type: T.Type) -> T {
        T(context: context)
    }

    func delete<T: NSManagedObject>(_ object: T) throws {
        context.delete(object)
        try saveIfNeeded()
    }
}
