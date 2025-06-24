//
//  CoreDataFactory.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 24.06.2025.
//

import Foundation

class CoreDataDataSourceFactory: AbstractDataSourceFactory {
    required init() { }
    
    func makeDesignPatternDataSource() -> DesignPatternDataSourceProtocol {
        return DesignPatternCoreDataDataSource()
    }
    
    func makeCodeExampleDataSource() -> CodeExampleDataSourceProtocol {
        return CodeExampleCoreDataDataSource()
    }
}
