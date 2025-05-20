//
//  MocksDataSourceFactory.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 13.05.2025.
//

import Foundation

class MocksDataSourceFactory: AbstractDataSourceFactory {
    required init() { }
    
    func makeDesignPatternDataSource() -> DesignPatternDataSourceProtocol {
        return DesignPatternMocksDataSource()
    }
    
    func makeCodeExampleDataSource() -> CodeExampleDataSourceProtocol {
        return CodeExampleMocksDataSource()
    }
}
