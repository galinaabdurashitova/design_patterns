//
//  ViewModelFactory.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 24.06.2025.
//

import Foundation

final class ViewModelFactory {
    @MainActor static func makeDesignPatternsListViewModel() -> DesignPatternsListViewModel {
        let dataSource = AvailableDataSource.coreData
        
        let patternRepo = DesignPatternRepository(source: dataSource)
        let codeExampleRepo = CodeExampleRepository(source: dataSource)
        let useCase = DesignPatternUseCase(repository: patternRepo, codeExampleRepository: codeExampleRepo)
        return DesignPatternsListViewModel(useCase: useCase)
    }
}
