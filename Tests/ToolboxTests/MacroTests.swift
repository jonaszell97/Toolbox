
#if canImport(ToolboxMacros)

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import ToolboxMacros
import XCTest

let testMacros: [String: Macro.Type] = [
    "DeriveConformances": AutomaticConformancesMacro.self,
]

final class MacroTests: XCTestCase {
    // Structs
    
    func testStructEquatableConformanceMacro() throws {
        assertMacroExpansion(
            """
            @DeriveConformances(types: ["Equatable"]) public struct MyStruct { var x: Int; var y: String }
            """,
            expandedSource: """
            public struct MyStruct { var x: Int; var y: String }
            
            extension MyStruct : Equatable {
                public static func == (lhs: Self, rhs: Self) -> Bool {
                    lhs.x == rhs.x && lhs.y == rhs.y
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testStructHashableConformanceMacro() throws {
        assertMacroExpansion(
            """
            @DeriveConformances(types: ["Hashable"]) public struct MyStruct { var x: Int; var y: String }
            """,
            expandedSource: """
            public struct MyStruct { var x: Int; var y: String }
            
            extension MyStruct : Hashable {
                public func hash(into hasher: inout Hasher) {
                    hasher.combine(self.x)
                    hasher.combine(self.y)
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testStructCodableConformanceMacro() throws {
        assertMacroExpansion(
            """
            @DeriveConformances(types: ["Codable"]) public struct MyStruct { var x: Int; var y: String }
            """,
            expandedSource: """
            public struct MyStruct { var x: Int; var y: String }
            
            extension MyStruct : Codable {
                enum CodingKeys: String, CodingKey {
                    case x, y
                }
            
                public func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: CodingKeys.self)
                    try container.encode(x, forKey: .x)
                    try container.encode(y, forKey: .y)
                }
            
                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    self.init(
                        x: try container.decode(Int.self, forKey: .x),
                        y: try container.decode(String .self, forKey: .y)
                    )
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testStructCustomStringConvertibleConformanceMacro() throws {
        assertMacroExpansion(
            """
            @DeriveConformances(types: ["CustomStringConvertible"]) public struct MyStruct { var x: Int; var y: String }
            """,
            expandedSource: """
            public struct MyStruct { var x: Int; var y: String }
            
            extension MyStruct : CustomStringConvertible {
                public var description: String {
                    return \"\"\"
                    MyStruct  {
                        x = \\(self.x)
                        y = \\(self.y)
                    }
                    \"\"\"
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testStructMemberwiseInitializerMacro() throws {
        assertMacroExpansion(
            """
            @DeriveConformances(types: ["memberwiseInitializer"]) public struct MyStruct { var x: Int = 3 + 4; var y: String }
            """,
            expandedSource: """
            public struct MyStruct { var x: Int = 3 + 4; var y: String }
            
            extension MyStruct  {
                /// Memberwise initializer.
                public init(x: Int = 3 + 4,
                            y: String ) {
                    self.x = x
                    self.y = y
                }
            }
            """,
            macros: testMacros
        )
    }
    
    // Classes
    
    func testClassEquatableConformanceMacro() throws {
        assertMacroExpansion(
            """
            @DeriveConformances(types: ["Equatable"]) public class MyClass { var x: Int; var y: String }
            """,
            expandedSource: """
            public class MyClass { var x: Int; var y: String }
            
            extension MyClass : Equatable {
                public static func == (lhs: Self, rhs: Self) -> Bool {
                    lhs.x == rhs.x && lhs.y == rhs.y
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testClassHashableConformanceMacro() throws {
        assertMacroExpansion(
            """
            @DeriveConformances(types: ["Hashable"]) public class MyClass { var x: Int; var y: String }
            """,
            expandedSource: """
            public class MyClass { var x: Int; var y: String }
            
            extension MyClass : Hashable {
                public func hash(into hasher: inout Hasher) {
                    hasher.combine(self.x)
                    hasher.combine(self.y)
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testClassCodableConformanceMacro() throws {
        assertMacroExpansion(
            """
            @DeriveConformances(types: ["Codable"]) public class MyClass { var x: Int; var y: String }
            """,
            expandedSource: """
            public class MyClass { var x: Int; var y: String }
            
            extension MyClass : Codable {
                enum CodingKeys: String, CodingKey {
                    case x, y
                }
            
                public func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: CodingKeys.self)
                    try container.encode(x, forKey: .x)
                    try container.encode(y, forKey: .y)
                }
            
                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    self.init(
                        x: try container.decode(Int.self, forKey: .x),
                        y: try container.decode(String .self, forKey: .y)
                    )
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testClassCustomStringConvertibleConformanceMacro() throws {
        assertMacroExpansion(
            """
            @DeriveConformances(types: ["CustomStringConvertible"]) public class MyClass { var x: Int; var y: String }
            """,
            expandedSource: """
            public class MyClass { var x: Int; var y: String }
            
            extension MyClass : CustomStringConvertible {
                public var description: String {
                    return \"\"\"
                    MyClass  {
                        x = \\(self.x)
                        y = \\(self.y)
                    }
                    \"\"\"
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testClassMemberwiseInitializerMacro() throws {
        assertMacroExpansion(
            """
            @DeriveConformances(types: ["memberwiseInitializer"]) public class MyClass { var x: Int = 3 + 4; var y: String }
            """,
            expandedSource: """
            public class MyClass { var x: Int = 3 + 4; var y: String }
            
            extension MyClass  {
                /// Memberwise initializer.
                public convenience init(x: Int = 3 + 4,
                                        y: String ) {
                    self.x = x
                    self.y = y
                }
            }
            """,
            macros: testMacros
        )
    }
    
    // Enums
    
    func testEnumEquatableConformanceMacro() throws {
        assertMacroExpansion(
            """
            @DeriveConformances(types: ["Equatable"]) public enum MyEnum { case a, b(c: String), d(e: Int = 5 * 6, f g: [Int]) }
            """,
            expandedSource: """
            public enum MyEnum { case a, b(c: String), d(e: Int = 5 * 6, f g: [Int]) }
            
            extension MyEnum : Equatable {
                public static func == (lhs: Self, rhs: Self) -> Bool {
                    switch lhs {
                    case .a:
                        guard case .a = rhs else {
                            return false
                        }

                        return true
                    case .b(let lhs_0):
                        guard case .b(let rhs_0) = rhs else {
                            return false
                        }

                        return lhs_0 == rhs_0
                    case .d(let lhs_0, let lhs_1):
                        guard case .d(let rhs_0, let rhs_1) = rhs else {
                            return false
                        }

                        return lhs_0 == rhs_0 && lhs_1 == rhs_1
                    }
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testEnumHashableConformanceMacro() throws {
        assertMacroExpansion(
            """
            @DeriveConformances(types: ["Hashable"]) public enum MyEnum { case a, b(c: String), d(e: Int = 5 * 6, f g: [Int]) }
            """,
            expandedSource: """
            public enum MyEnum { case a, b(c: String), d(e: Int = 5 * 6, f g: [Int]) }
            
            extension MyEnum : Hashable {
                public func hash(into hasher: inout Hasher) {
                    switch self {
                    case .a:
                        hasher.combine("a")
                    case .b(let v0):
                        hasher.combine("b")
                        hasher.combine(v0)
                    case .d(let v0, let v1):
                        hasher.combine("d")
                        hasher.combine(v0)
                        hasher.combine(v1)
                    }
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testEnumCodableConformanceMacro() throws {
        assertMacroExpansion(
            """
            @DeriveConformances(types: ["Codable"]) public enum MyEnum { case a, b(c: String), d(_ e: Int = 5 * 6, f g: [Int]) }
            """,
            expandedSource: """
            public enum MyEnum { case a, b(c: String), d(_ e: Int = 5 * 6, f g: [Int]) }
            
            extension MyEnum : Codable {
                enum CodingKeys: String, CodingKey {
                    case a, b, d
                }

                enum dCodingKeys: CodingKey {
                    case _0, _1
                }

                var codingKey: CodingKeys {
                    switch self {
                    case .a:
                        return .a
                    case .b:
                        return .b
                    case .d:
                        return .d
                    }
                }

                public func encode(to encoder: Encoder) throws {
                    var container = encoder.container(keyedBy: CodingKeys.self)
                    switch self {
                    case .a:
                        try container.encodeNil(forKey: .a)
                    case .b(let v):
                        try container.encode(v, forKey: .b)
                    case .d(let v0, let v1):
                        var nestedContainer = container.nestedContainer(keyedBy: dCodingKeys.self, forKey: .d)
                        try nestedContainer.encode(v0, forKey: ._0)
                        try nestedContainer.encode(v1, forKey: ._1)
                    }
                }

                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    switch container.allKeys.first {
                    case .a:
                        _ = try container.decodeNil(forKey: .a)
                        self = .a
                    case .b:
                        let v = try container.decode(String.self, forKey: .b)
                        self = .b(c: v)
                    case .d:
                        let nestedContainer = try container.nestedContainer(keyedBy: dCodingKeys.self, forKey: .d)
                        let v0 = try nestedContainer.decode(Int .self, forKey: ._0)
                        let v1 = try nestedContainer.decode([Int].self, forKey: ._1)
                        self = .d(v0, f: v1)
                    default:
                        throw DecodingError.dataCorrupted(
                            DecodingError.Context(
                                codingPath: container.codingPath,
                                debugDescription: "Unable to decode enum MyEnum "
                            )
                        )
                    }
                }
            }
            """,
            macros: testMacros
        )
    }
    
    func testEnumCustomStringConvertibleConformanceMacro() throws {
        assertMacroExpansion(
            """
            @DeriveConformances(types: ["CustomStringConvertible"]) public enum MyEnum { case a, b(c: String), d(_ e: Int = 5 * 6, f g: [Int]) }
            """,
            expandedSource: """
            public enum MyEnum { case a, b(c: String), d(_ e: Int = 5 * 6, f g: [Int]) }
            
            extension MyEnum : CustomStringConvertible {
                public var description: String {
                    switch self {
                    case .a:
                        return ".a()"
                    case .b(let v0):
                        return ".b(c: \\(v0))"
                    case .d(let v0, let v1):
                        return ".d(\\(v0), f: \\(v1))"
                    }
                }
            }
            """,
            macros: testMacros
        )
    }
}

#endif
