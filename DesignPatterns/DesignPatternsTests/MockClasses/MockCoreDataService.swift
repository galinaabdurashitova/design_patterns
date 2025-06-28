//
//  MockCoreDataService.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 27.06.2025.
//

import CoreData
@testable import DesignPatterns

final class MockCoreDataService: CoreDataServiceProtocol {
    private let context: NSManagedObjectContext
    var throwError = false
    var didCallSave = false

    var fetchResult: [NSManagedObject] = []

    init() {
        let container = NSPersistentContainer(name: "DesignPatterns")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }

        self.context = container.viewContext
    }

    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> [T] {
        if throwError { throw TestError.sample }
        return fetchResult as? [T] ?? []
    }

    func fetchOne<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> T? {
        if throwError { throw TestError.sample }
        return fetchResult.first(where: { $0 is T }) as? T
    }

    func saveIfNeeded() throws {
        if throwError { throw TestError.sample }
        didCallSave = true
    }

    func create<T: NSManagedObject>(_ type: T.Type) -> T {
        let object = T(context: context)
        fetchResult.append(object)
        return object
    }

    func delete<T: NSManagedObject>(_ object: T) throws {
        if throwError { throw TestError.sample }
        context.delete(object)
    }

    var testContext: NSManagedObjectContext {
        return context
    }
}
