//
//  DesignPatternsApp.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 08.05.2025.
//

import SwiftUI
import UIKit

@main
struct DesignPatternsApp: App {
    init() {
        #if canImport(UIKit)
        if ProcessInfo.processInfo.arguments.contains("-disableAnimations") {
            UIView.setAnimationsEnabled(false)
        }
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
