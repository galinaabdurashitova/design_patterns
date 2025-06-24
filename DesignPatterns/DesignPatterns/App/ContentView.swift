//
//  ContentView.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        DesignPatternsListView(viewModel: ViewModelFactory.makeDesignPatternsListViewModel())
    }
}

#Preview {
    ContentView()
}
