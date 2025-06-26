//
//  MockFilter.swift
//  DesignPatternsTests
//
//  Created by Galina Abdurashitova on 26.06.2025.
//

import Foundation
@testable import DesignPatterns

class MockFilter: FilterProtocol {
    typealias T = DesignPattern

    var receivedItems: [DesignPattern] = []
    var receivedSpecificationType: String = ""
    var filteredResult: [DesignPattern] = []

    func filter<Spec: Specification>(items: [DesignPattern], with specification: Spec) -> [DesignPattern] where Spec.T == DesignPattern {
        receivedItems = items
        receivedSpecificationType = String(describing: type(of: specification))
        return filteredResult
    }
}
