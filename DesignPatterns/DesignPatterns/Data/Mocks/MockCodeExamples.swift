//
//  MockCodeExamples.swift
//  DesignPatterns
//
//  Created by Galina Abdurashitova on 20.05.2025.
//

import Foundation

enum MockCodeExamples {
    static var codeExamples: [CodeExample] = [

        // MARK: - Specification: Domain Models

        CodeExample(
            patternId: MockDesignPatterns.patterns[0].id,
            code: """
            enum Color {
                case red
                case green
                case blue
            }
            """
        ),
        CodeExample(
            patternId: MockDesignPatterns.patterns[0].id,
            code: """
            enum Size {
                case small
                case medium
                case large
                case yuge
            }
            """
        ),
        CodeExample(
            patternId: MockDesignPatterns.patterns[0].id,
            code: """
            class Product {
                var name: String
                var color: Color
                var size: Size
                
                init(_ name: String, _ color: Color, _ size: Size) {
                    self.name = name
                    self.color = color
                    self.size = size
                }
            }
            """
        ),

        // MARK: - Specification: Naive filter

        CodeExample(
            patternId: MockDesignPatterns.patterns[0].id,
            code: """
            class ProductFilter {
                func filterByColor(_ products: [Product], _ color: Color) -> [Product] {
                    products.filter { $0.color == color }
                }

                func filterBySize(_ products: [Product], _ size: Size) -> [Product] {
                    products.filter { $0.size == size }
                }

                func filterBySizeAndColor(_ products: [Product], _ size: Size, _ color: Color) -> [Product] {
                    products.filter { $0.size == size && $0.color == color }
                }
            }
            """
        ),

        // MARK: - Specification: Protocols

        CodeExample(
            patternId: MockDesignPatterns.patterns[0].id,
            code: """
            protocol Specification {
                associatedtype T
                func isSatisfied(_ item: T) -> Bool
            }
            """
        ),
        CodeExample(
            patternId: MockDesignPatterns.patterns[0].id,
            code: """
            protocol Filter {
                associatedtype T
                func filter<Spec: Specification>(_ items: [T], _ spec: Spec) -> [T]
                where Spec.T == T
            }
            """
        ),

        // MARK: - Specification: Concrete Specs

        CodeExample(
            patternId: MockDesignPatterns.patterns[0].id,
            code: """
            class ColorSpecification: Specification {
                typealias T = Product
                let color: Color
                
                init(_ color: Color) {
                    self.color = color
                }
                
                func isSatisfied(_ item: Product) -> Bool {
                    item.color == color
                }
            }
            """
        ),
        CodeExample(
            patternId: MockDesignPatterns.patterns[0].id,
            code: """
            class SizeSpecification: Specification {
                typealias T = Product
                let size: Size
                
                init(_ size: Size) {
                    self.size = size
                }
                
                func isSatisfied(_ item: Product) -> Bool {
                    item.size == size
                }
            }
            """
        ),

        CodeExample(
            patternId: MockDesignPatterns.patterns[0].id,
            code: """
            class AndSpecification<T, SpecA: Specification, SpecB: Specification>: Specification
            where SpecA.T == SpecB.T, T == SpecA.T {
                let first: SpecA
                let second: SpecB
                
                init(_ first: SpecA, _ second: SpecB) {
                    self.first = first
                    self.second = second
                }
                
                func isSatisfied(_ item: T) -> Bool {
                    first.isSatisfied(item) && second.isSatisfied(item)
                }
            }
            """
        ),

        // MARK: - Specification: Better Filter

        CodeExample(
            patternId: MockDesignPatterns.patterns[0].id,
            code: """
            class BetterFilter: Filter {
                typealias T = Product
                
                func filter<Spec: Specification>(_ items: [Product], _ spec: Spec) -> [T]
                where Spec.T == T {
                    items.filter { spec.isSatisfied($0) }
                }
            }
            """
        ),

        // MARK: - Specification: Usage

        CodeExample(
            patternId: MockDesignPatterns.patterns[0].id,
            code: """
            let apple = Product("Apple", .green, .small)
            let tree = Product("Tree", .green, .large)
            let house = Product("House", .blue, .large)
            let products = [apple, tree, house]
            """
        ),

        CodeExample(
            patternId: MockDesignPatterns.patterns[0].id,
            code: """
            let pf = ProductFilter()
            for p in pf.filterByColor(products, .green) {
                print(" - \\(p.name) is green")
            }
            """
        ),

        CodeExample(
            patternId: MockDesignPatterns.patterns[0].id,
            code: """
            let bf = BetterFilter()
            for p in bf.filter(products, ColorSpecification(.green)) {
                print(" - \\(p.name) is green")
            }
            """
        ),

        CodeExample(
            patternId: MockDesignPatterns.patterns[0].id,
            code: """
            for p in bf.filter(
                products,
                AndSpecification(
                    ColorSpecification(.blue),
                    SizeSpecification(.large)
                )
            ) {
                print(" - \\(p.name) is large and blue")
            }
            """
        ),
        
        // MARK: - Builder

        CodeExample(
            patternId: MockDesignPatterns.patterns[1].id,
            code: """
            let hello = "hello"
            var result = "<p>\\(hello)</p>"
            print(result)
            """
        ),

        CodeExample(
            patternId: MockDesignPatterns.patterns[1].id,
            code: """
            let words = ["hello", "world"]
            result = "<ul>"
            for word in words {
                result.append("<li>\\(word)</li>")
            }
            result.append("</ul>")
            print(result)
            """
        ),

        // MARK: - Builder: HtmlElement

        CodeExample(
            patternId: MockDesignPatterns.patterns[1].id,
            code: """
            class HtmlElement: CustomStringConvertible {
                var name = ""
                var text = ""
                var elements = [HtmlElement]()
                private let indentSize = 2
                
                init() {}
                init(name: String, text: String) {
                    self.name = name
                    self.text = text
                }
                
                private func description(_ indent: Int) -> String {
                    var result = ""
                    let i = String(repeating: " ", count: indent)
                    result += "\\(i)<\\(name)>\\n"
                    
                    if (!text.isEmpty) {
                        result += String(repeating: " ",
                                         count: indentSize * (indent + 1))
                        result += text
                        result += "\\n"
                    }
                    
                    for e in elements {
                        result += e.description(indent + 1)
                    }
                    
                    result += "\\(i)</\\(name)>\\n"
                    
                    return result
                }
                
                public var description: String {
                    return description(0)
                }
            }
            """
        ),

        // MARK: - Builder: HtmlBuilder

        CodeExample(
            patternId: MockDesignPatterns.patterns[1].id,
            code: """
            class HtmlBuilder: CustomStringConvertible {
                private let rootName: String
                var root = HtmlElement()
                
                init(rootName: String) {
                    self.rootName = rootName
                    root.name = rootName
                }
                
                func addChild(name: String, text: String) {
                    let e = HtmlElement(name: name, text: text)
                    root.elements.append(e)
                }
                
                func addChildFluent(childName: String, childText: String) -> HtmlBuilder {
                    let e = HtmlElement(name: childName, text: childText)
                    root.elements.append(e)
                    return self
                }
                
                public var description: String {
                    return root.description
                }
                
                func clear() {
                    root = HtmlElement(name: rootName, text: "")
                }
            }
            """
        ),

        // MARK: - Builder: Usage HtmlBuilder

        CodeExample(
            patternId: MockDesignPatterns.patterns[1].id,
            code: """
            let builder = HtmlBuilder(rootName: "ul")
            builder.addChild(name: "li", text: "hello")
            builder.addChild(name: "li", text: "world")
            print(builder)
            """
        ),
        
        // MARK: - Abstract Factory
    
        CodeExample(patternId: MockDesignPatterns.patterns[2].id, code: "let c = 3")
    ]
}
