//
//  DesignPatternBuilder.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 11.05.2025.
//

import Foundation

extension DesignPattern {
    static func builder() -> Builder { .init() }
    
    final class Builder {
        private var id: UUID = UUID()
        private var name: String = ""
        private var type: DesignPatternType = .behavioral
        private var description: String = ""
        
        func setName(_ name: String) -> Self {
            self.name = name
            return self
        }
        
        func setType(_ type: DesignPatternType) -> Self {
            self.type = type
            return self
        }
        
        func setDescription(_ description: String) -> Self {
            self.description = description
            return self
        }
        
        func build() throws -> DesignPattern {
            guard !name.isEmpty else { throw DesignPatternError.emptyName }
            
            return DesignPattern(
                id: id,
                name: name,
                type: type,
                description: description
            )
        }
    }
}
