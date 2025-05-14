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
