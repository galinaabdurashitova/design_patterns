//
//  AvailableDataSource.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 20.05.2025.
//

import Foundation

enum AvailableDataSource {
    case mocks, api, coreData
    
    var factory: AbstractDataSourceFactory {
        switch self {
        case .mocks:
            return MocksDataSourceFactory()
        case .api:
            return APIDataSourceFactory()
        case .coreData:
            return CoreDataDataSourceFactory()
        }
    }
    
    func makeDesignPatternDataSource() -> DesignPatternDataSourceProtocol {
        return factory.makeDesignPatternDataSource()
    }

    func makeCodeExampleDataSource() -> CodeExampleDataSourceProtocol {
        return factory.makeCodeExampleDataSource()
    }
}
