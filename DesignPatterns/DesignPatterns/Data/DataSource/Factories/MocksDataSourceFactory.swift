//
//  MocksDataSourceFactory.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 13.05.2025.
//

import Foundation

class MocksDataSourceFactory: DataSourceFactory {
    required init() { }
    func makeDataSource() -> DataSourceProtocol {
        return DesignPatternMocksDataSource()
    }
}
