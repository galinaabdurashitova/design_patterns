//
//  APIDataSourceFactory.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 13.05.2025.
//

import Foundation

class APIDataSourceFactory: DataSourceFactory {
    required init() { }
    
    let baseURL = URL(string: "https://api.com")!
    
    func makeDataSource() -> DataSourceProtocol {
        return DesignPatternAPIDataSource(baseURL: baseURL)
    }
}
