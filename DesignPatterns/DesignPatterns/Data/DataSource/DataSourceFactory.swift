//
//  DataSourceFactory.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 12.05.2025.
//

import Foundation

protocol DataSourceFactory {
    init()
    func makeDataSource() -> DataSourceProtocol
}

class MocksDataSourceFactory: DataSourceFactory {
    required init() { }
    func makeDataSource() -> DataSourceProtocol {
        return DesignPatternMocksDataSource()
    }
}

class APIDataSourceFactory: DataSourceFactory {
    required init() { }
    func makeDataSource() -> DataSourceProtocol {
        return DesignPatternAPIDataSource()
    }
}
