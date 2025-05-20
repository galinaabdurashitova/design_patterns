//
//  APIDataSourceFactory.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 13.05.2025.
//

import Foundation

class APIDataSourceFactory: AbstractDataSourceFactory {
    required init() { }
    
    let baseURL = URL(string: "https://api.com")!
    
    func makeDesignPatternDataSource() -> DesignPatternDataSourceProtocol {
        return DesignPatternAPIDataSource(baseURL: baseURL)
    }
    
    func makeCodeExapleDataSource() -> CodeExampleDataSourceProtocol {
        return CodeExampleAPIDataSource(baseURL: baseURL)
    }
}
