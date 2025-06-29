//
//  ViewModelFactory.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 24.06.2025.
//

import Foundation

final class ViewModelFactory {
    @MainActor static func makeDesignPatternsListViewModel() -> DesignPatternsListViewModel {
        let args = ProcessInfo.processInfo.arguments
        let isUITest = args.contains("--UITests")
        let dataSource: AvailableDataSource = isUITest
            ? .mocks
            : .coreData
        
        let patternRepo = DesignPatternRepository(dataSource: dataSource.makeDesignPatternDataSource())
        let codeExampleRepo = CodeExampleRepository(dataSource: dataSource.makeCodeExampleDataSource())
        let useCase = DesignPatternUseCase(repository: patternRepo, codeExampleRepository: codeExampleRepo)
        return DesignPatternsListViewModel(useCase: useCase)
    }
}
