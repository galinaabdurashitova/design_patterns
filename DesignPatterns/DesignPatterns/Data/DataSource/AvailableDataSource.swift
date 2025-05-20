//
//  AvailableDataSource.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 20.05.2025.
//

import Foundation

enum AvailableDataSource {
    case mocks
    case api
    
    var factory: AbstractDataSourceFactory {
        switch self {
        case .mocks:
            return MocksDataSourceFactory()
        case .api:
            return APIDataSourceFactory()
        }
    }
}
