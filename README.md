# DesignPatterns App (SwiftUI + Clean Architecture) — currently WIP

[![CI](https://github.com/galinaabdurashitova/design_patterns/actions/workflows/ios-ci.yml/badge.svg?branch=main)](https://github.com/galinaabdurashitova/design_patterns/actions/workflows/ios-ci.yml) ![coverage](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/galinaabdurashitova/design_patterns/main/docs/coverage.json)

This is a demo iOS application built with **SwiftUI** that demonstrates the **real-world use of software design patterns** in a clean, modular architecture.

The application was created with the goal of showcasing:
- Practical usage of **creational**, **structural**, and **behavioral** design patterns
- Clean, testable architecture with clear separation of concerns
- Scalable data layer with support for multiple data sources
- Async data flow and Swift concurrency in SwiftUI

> All the patterns listed in the UI are **actually implemented in the codebase** and govern the core architecture of the app.

---

## ✨ Features

- 📋 **List of software design patterns**, categorized by type
- 🚦 **State-driven UI** using a generic `UIState<T>` enum
- 🔍 Debounced and composable **filtering logic** via Specification pattern
- 🧰 **Combine-driven** state observation with @Published + debounce
- 🚀 Fully **asynchronous logic** using `async/await`
- 🎯 SwiftUI + MVVM + DI-ready
- 💡 Custom overlay with animation to display pattern details
- 🎨 Visual styling based on pattern type (emoji, color, icon)

---

## 🧩 Design Patterns Applied in Codebase

| Pattern              | Type         | Where It’s Used                                                  |
|----------------------|--------------|------------------------------------------------------------------|
| **Builder**          | Creational   | Constructing `DesignPattern` models safely and incrementally     |
| **Abstract Factory** | Creational   | Switching between mock and API data sources                      |
| **Specification**    | Behavioral   | Filtering patterns by name/type with composable specifications   |

You can find all patterns in action inside:
- `UseCase/`, `Repositories/`, `Specifications/`, and `Utilities/` folders.

---

## 🧪 UI Preview

<p align="center">
  <img src="screenshots/1_main_screen.png" width="160"/>
  <img src="screenshots/2_design_pattern_view.png" width="160"/>
  <img src="screenshots/3_search.png" width="160"/>
  <img src="screenshots/4_type_filter_bottom_sheet.png" width="160"/>
  <img src="screenshots/5_type_filter_applied.png" width="160"/>
</p>

---

## 🧪 Tests

This project includes full **automated testing** for all layers:

| Test Type      | Target                     | Description                                         |
|----------------|----------------------------|-----------------------------------------------------|
| ✅ Unit         | `DesignPatternsTests`       | Tests for use cases, specifications, and utilities  |
| ✅ Snapshot     | `DesignPatternsSnapshotTests` | UI snapshot testing for SwiftUI views               |
| ✅ UI           | `DesignPatternsUITests`     | End-to-end UI tests using accessibility identifiers |

All tests are integrated with CI and verified automatically on each push to `main`.

---

## 🚀 CI/CD

Basic **GitHub Actions** setup is included and runs on each push to `main`. The pipeline:

1. Builds the app and resolves all SwiftPM dependencies
2. Runs:
   - Unit tests
   - Snapshot tests
   - UI tests (with full simulator launch and verification)

> CI runs on `macos-15` using Xcode 16.4 and iPhone 16 Pro simulator

---

## 🛠 Technologies Used

- Swift 5.10
- SwiftUI
- MVVM
- Combine (for state observation and filtering)
- Swift Concurrency (`async/await`)
- Dependency Inversion & Protocol-Oriented Design
- SnapshotTesting (by Point-Free)
- XCTest for all test layers
- GitHub Actions (CI)
