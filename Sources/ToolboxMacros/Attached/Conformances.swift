
import SwiftSyntax
import SwiftSyntaxMacros

fileprivate protocol ClassOrStructDecl {
    var name: TokenSyntax { get }
    var memberBlock: MemberBlockSyntax { get }
    var modifiers: DeclModifierListSyntax { get }
}

extension StructDeclSyntax: ClassOrStructDecl {}
extension ClassDeclSyntax: ClassOrStructDecl {}

public struct AutomaticConformancesMacro: ExtensionMacro {
    public static func expansion(of node: AttributeSyntax,
                                 attachedTo declaration: some DeclGroupSyntax,
                                 providingExtensionsOf type: some TypeSyntaxProtocol,
                                 conformingTo protocols: [TypeSyntax],
                                 in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        guard let arguments = getStringArguments(node: node) else {
            return []
        }
        
        var result = [ExtensionDeclSyntax]()
        for argument in arguments {
            switch argument {
            case "Equatable":
                guard let extensionDecl = Self.generateEquatableConformance(declaration: declaration) else {
                    break
                }
                
                result.append(extensionDecl)
            case "Hashable":
                guard let extensionDecl = Self.generateHashableConformance(declaration: declaration) else {
                    break
                }
                
                result.append(extensionDecl)
            case "Codable":
                guard let extensionDecl = Self.generateCodableConformance(declaration: declaration) else {
                    break
                }
                
                result.append(extensionDecl)
            case "CustomStringConvertible":
                guard let extensionDecl = Self.generateCustomStringConvertibleConformance(declaration: declaration) else {
                    break
                }
                
                result.append(extensionDecl)
            case "memberwiseInitializer":
                guard let extensionDecl = Self.generateMemberwiseInitializer(declaration: declaration) else {
                    break
                }
                
                result.append(extensionDecl)
            default:
                throw MacroError.invalidArgument("Invalid protocol: \(argument)")
            }
        }
        
        return result
    }
}

// MARK: Equatable conformance

fileprivate extension AutomaticConformancesMacro {
    static func generateEquatableConformance(declaration: some DeclGroupSyntax) -> ExtensionDeclSyntax? {
        if let structType = declaration.as(StructDeclSyntax.self) {
            return generateEquatableConformance(classOrStruct: structType)
        }
        if let classType = declaration.as(ClassDeclSyntax.self) {
            return generateEquatableConformance(classOrStruct: classType)
        }
        
        if let enumType = declaration.as(EnumDeclSyntax.self) {
            return generateEquatableConformance(declaration: enumType)
        }
        
        return nil
    }
    
    static func generateEquatableConformance(classOrStruct declaration: some ClassOrStructDecl) -> ExtensionDeclSyntax? {
        let properties = getPropertyDeclarations(of: declaration.memberBlock)
        let accessLevel = getAccessModifier(for: declaration.modifiers)
        
        let syntax: DeclSyntax = """
extension \(declaration.name): Equatable {
    \(raw: accessLevel)static func ==(lhs: Self, rhs: Self) -> Bool {
        \(raw: properties.map { "lhs.\($0.name) == rhs.\($0.name)" }.joined(separator: " && "))
    }
}
"""
        
        return syntax.as(ExtensionDeclSyntax.self)
    }
    
    static func generateEquatableConformance(declaration: EnumDeclSyntax) -> ExtensionDeclSyntax? {
        let cases = getEnumCaseDeclarations(of: declaration)
        let accessLevel = getAccessModifier(for: declaration.modifiers)
        
        var caseSyntax: [DeclSyntax] = []
        for c in cases {
            let lhsClause = c.parameters.isEmpty ? "" : "(\(c.parameters.enumerated().map { index, _ in "let lhs_\(index)" }.joined(separator: ", ")))"
            let rhsClause = c.parameters.isEmpty ? "" : "(\(c.parameters.enumerated().map { index, _ in "let rhs_\(index)" }.joined(separator: ", ")))"
            let returnValue = c.parameters.isEmpty ? "true" : c.parameters.enumerated().map { index, _ in "lhs_\(index) == rhs_\(index)" }.joined(separator: " && ")
            
            caseSyntax.append("""
            case .\(c.name)\(raw: lhsClause):
                        guard case .\(c.name)\(raw: rhsClause) = rhs else {
                            return false
                        }
                        
                        return \(raw: returnValue)
            """)
        }
        
        let syntax: DeclSyntax = """
extension \(declaration.name): Equatable {
    \(raw: accessLevel)static func ==(lhs: Self, rhs: Self) -> Bool {
        switch lhs {
        \(raw: caseSyntax.map { $0.description }.joined(separator: "\n        ") )
        }
    }
}
"""
        
        return syntax.as(ExtensionDeclSyntax.self)
    }
}

// MARK: Hashable conformance

fileprivate extension AutomaticConformancesMacro {
    static func generateHashableConformance(declaration: some DeclGroupSyntax) -> ExtensionDeclSyntax? {
        if let structType = declaration.as(StructDeclSyntax.self) {
            return generateHashableConformance(classOrStruct: structType)
        }
        if let classType = declaration.as(ClassDeclSyntax.self) {
            return generateHashableConformance(classOrStruct: classType)
        }
        if let enumType = declaration.as(EnumDeclSyntax.self) {
            return generateHashableConformance(declaration: enumType)
        }
        
        return nil
    }
    
    static func generateHashableConformance(classOrStruct declaration: some ClassOrStructDecl) -> ExtensionDeclSyntax? {
        let properties = getPropertyDeclarations(of: declaration.memberBlock)
        let accessLevel = getAccessModifier(for: declaration.modifiers)
        
        let syntax: DeclSyntax = """
extension \(declaration.name): Hashable {
    \(raw: accessLevel)func hash(into hasher: inout Hasher) {
        \(raw: properties.map { "hasher.combine(self.\($0.name))" }.joined(separator: "\n        "))
    }
}
"""
        
        return syntax.as(ExtensionDeclSyntax.self)
    }
    
    static func generateHashableConformance(declaration: EnumDeclSyntax) -> ExtensionDeclSyntax? {
        let cases = getEnumCaseDeclarations(of: declaration)
        let accessLevel = getAccessModifier(for: declaration.modifiers)
        
        var caseSyntax: [DeclSyntax] = []
        for c in cases {
            let selfClause = c.parameters.isEmpty ? "" : "(\(c.parameters.enumerated().map { index, _ in "let v\(index)" }.joined(separator: ", ")))"
            
            caseSyntax.append("""
            case .\(c.name)\(raw: selfClause):
                        hasher.combine("\(c.name)")
                        \(raw: c.parameters.enumerated().map { index, _ in "hasher.combine(v\(index))" }.joined(separator: "\n            "))
            """)
        }
        
        let syntax: DeclSyntax = """
extension \(declaration.name): Hashable {
    \(raw: accessLevel)func hash(into hasher: inout Hasher) {
        switch self {
        \(raw: caseSyntax.map { $0.description }.joined(separator: "\n        ") )
        }
    }
}
"""
        
        return syntax.as(ExtensionDeclSyntax.self)
    }
}

// MARK: Codable conformance

fileprivate extension AutomaticConformancesMacro {
    static func generateCodableConformance(declaration: some DeclGroupSyntax) -> ExtensionDeclSyntax? {
        if let structType = declaration.as(StructDeclSyntax.self) {
            return generateCodableConformance(classOrStruct: structType)
        }
        if let classType = declaration.as(ClassDeclSyntax.self) {
            return generateCodableConformance(classOrStruct: classType)
        }
        if let enumType = declaration.as(EnumDeclSyntax.self) {
            return generateCodableConformance(declaration: enumType)
        }
        
        return nil
    }
    
    static func generateCodableConformance(classOrStruct declaration: some ClassOrStructDecl) -> ExtensionDeclSyntax? {
        let properties = getPropertyDeclarations(of: declaration.memberBlock)
        let accessLevel = getAccessModifier(for: declaration.modifiers)
        
        let syntax: DeclSyntax = """
extension \(declaration.name): Codable {
    enum CodingKeys: String, CodingKey {
        case \(raw: properties.map { "\($0.name)" }.joined(separator: ", "))
    }

    \(raw: accessLevel)func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        \(raw: properties.map { "try container.encode(\($0.name), forKey: .\($0.name))" }.joined(separator: "\n        "))
    }

    \(raw: accessLevel)init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            \(raw: properties.map { "\($0.name): try container.decode(\($0.type).self, forKey: .\($0.name))" }.joined(separator: ",\n            "))
        )
    }
}
"""
        
        return syntax.as(ExtensionDeclSyntax.self)
    }
    
    static func generateCodableConformance(declaration: EnumDeclSyntax) -> ExtensionDeclSyntax? {
        let cases = getEnumCaseDeclarations(of: declaration)
        let accessLevel = getAccessModifier(for: declaration.modifiers)
        
        var encodeSyntax: [DeclSyntax] = []
        var decodeSyntax: [DeclSyntax] = []
        var codingKeysSyntax: [DeclSyntax] = []
        
        for c in cases {
            if c.parameters.isEmpty {
                encodeSyntax.append("""
                case .\(c.name):
                            try container.encodeNil(forKey: .\(c.name))
                """)
                decodeSyntax.append("""
                case .\(c.name):
                            _ = try container.decodeNil(forKey: .\(c.name))
                            self = .\(c.name)
                """)
            }
            else if c.parameters.count == 1 {
                encodeSyntax.append("""
                case .\(c.name)(let v):
                            try container.encode(v, forKey: .\(c.name))
                """)
                decodeSyntax.append("""
                case .\(c.name):
                            let v = try container.decode(\(c.parameters[0].type).self, forKey: .\(c.name))
                            self = .\(c.name)(\(raw: c.parameters[0].label)v)
                """)
            }
            else {
                codingKeysSyntax.append("""
                enum \(c.name)CodingKeys: CodingKey {
                        case \(raw: c.parameters.enumerated().map { index, _ in "_\(index)" }.joined(separator: ", "))
                }
                """)
                
                encodeSyntax.append("""
                case .\(c.name)(\(raw: c.parameters.enumerated().map { index, _ in "let v\(index)" }.joined(separator: ", "))):
                            var nestedContainer = container.nestedContainer(keyedBy: \(c.name)CodingKeys.self, forKey: .\(c.name))
                            \(raw: c.parameters.enumerated().map { index, _ in "try nestedContainer.encode(v\(index), forKey: ._\(index))" }.joined(separator: "\n            "))
                """)
                
                decodeSyntax.append("""
                case .\(c.name):
                            let nestedContainer = try container.nestedContainer(keyedBy: \(c.name)CodingKeys.self, forKey: .\(c.name))
                            \(raw: c.parameters.enumerated().map { index, param in "let v\(index) = try nestedContainer.decode(\(param.type).self, forKey: ._\(index))" }.joined(separator: "\n            "))
                            self = .\(c.name)(\(raw: c.parameters.enumerated().map { index, param in "\(param.label)v\(index)" }.joined(separator: ", ")))
                """)
            }
        }
        
        let syntax: DeclSyntax = """
extension \(declaration.name): Codable {
    enum CodingKeys: String, CodingKey {
        case \(raw: cases.map { "\($0.name)" }.joined(separator: ", "))
    }

    \(raw: codingKeysSyntax.map { $0.description }.joined(separator: "\n    ") )

    var codingKey: CodingKeys {
        switch self {
        \(raw: cases.map { "case .\($0.name): return .\($0.name)" }.joined(separator: "\n        "))
        }
    }

    \(raw: accessLevel)func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        \(raw: encodeSyntax.map { $0.description }.joined(separator: "\n        ") )
        }
    }

    \(raw: accessLevel)init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch container.allKeys.first {
        \(raw: decodeSyntax.map { $0.description }.joined(separator: "\n        ") )
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Unable to decode enum \(declaration.name)"
                )
            )
        }
    }
}
"""
        
        return syntax.as(ExtensionDeclSyntax.self)
    }
}

// MARK: CustomStringConvertible conformance

fileprivate extension AutomaticConformancesMacro {
    static func generateCustomStringConvertibleConformance(declaration: some DeclGroupSyntax) -> ExtensionDeclSyntax? {
        if let structType = declaration.as(StructDeclSyntax.self) {
            return generateCustomStringConvertibleConformance(classOrStruct: structType)
        }
        if let classType = declaration.as(ClassDeclSyntax.self) {
            return generateCustomStringConvertibleConformance(classOrStruct: classType)
        }
        if let enumType = declaration.as(EnumDeclSyntax.self) {
            return generateCustomStringConvertibleConformance(declaration: enumType)
        }
        
        return nil
    }
    
    static func generateCustomStringConvertibleConformance(classOrStruct declaration: some ClassOrStructDecl) -> ExtensionDeclSyntax? {
        let properties = getPropertyDeclarations(of: declaration.memberBlock)
        let accessLevel = getAccessModifier(for: declaration.modifiers)
        
        let syntax: DeclSyntax = """
extension \(declaration.name): CustomStringConvertible {
    \(raw: accessLevel)var description: String {
        return \"\"\"
        \(declaration.name) {
            \(raw: properties.map { "\($0.name) = \\(self.\($0.name))" }.joined(separator: "\n            "))
        }
        \"\"\"
    }
}
"""
        
        return syntax.as(ExtensionDeclSyntax.self)
    }
    
    static func generateCustomStringConvertibleConformance(declaration: EnumDeclSyntax) -> ExtensionDeclSyntax? {
        let cases = getEnumCaseDeclarations(of: declaration)
        let accessLevel = getAccessModifier(for: declaration.modifiers)
        
        var caseSyntax: [DeclSyntax] = []
        for c in cases {
            let selfClause = c.parameters.isEmpty ? "" : "(\(c.parameters.enumerated().map { index, _ in "let v\(index)" }.joined(separator: ", ")))"
            
            caseSyntax.append("""
            case .\(c.name)\(raw: selfClause):
                        return ".\(c.name)(\(raw: c.parameters.enumerated().map { index, param in "\(param.label)\\(v\(index))" }.joined(separator: ", ")))"
            """)
        }
        
        let syntax: DeclSyntax = """
extension \(declaration.name): CustomStringConvertible {
    \(raw: accessLevel)var description: String {
        switch self {
        \(raw: caseSyntax.map { $0.description }.joined(separator: "\n        ") )
        }
    }
}
"""
        
        return syntax.as(ExtensionDeclSyntax.self)
    }
}

// MARK: Memberwise initializer

extension AutomaticConformancesMacro {
    static func generateMemberwiseInitializer(declaration: some DeclGroupSyntax) -> ExtensionDeclSyntax? {
        if let structType = declaration.as(StructDeclSyntax.self) {
            return generateMemberwiseInitializer(declaration: structType)
        }
        
        if let classType = declaration.as(ClassDeclSyntax.self) {
            return generateMemberwiseInitializer(declaration: classType)
        }
        
        return nil
    }
    
    static func generateMemberwiseInitializer(declaration: StructDeclSyntax) -> ExtensionDeclSyntax? {
        let properties = getPropertyDeclarations(of: declaration.memberBlock)
        let accessLevel = getAccessModifier(for: declaration.modifiers)
        
        let syntax: DeclSyntax = """
extension \(declaration.name) {
    /// Memberwise initializer.
    \(raw: accessLevel)init(\(raw: properties.map { "\($0.name): \($0.type)\($0.initializerExpression != nil ? "\($0.initializerExpression!)" : "")" }.joined(separator: ",\n                "))) {
        \(raw: properties.map { "self.\($0.name) = \($0.name)" }.joined(separator: "\n        "))
    }
}
"""
        
        return syntax.as(ExtensionDeclSyntax.self)
    }
    
    static func generateMemberwiseInitializer(declaration: ClassDeclSyntax) -> ExtensionDeclSyntax? {
        let properties = getPropertyDeclarations(of: declaration.memberBlock)
        let accessLevel = getAccessModifier(for: declaration.modifiers)
        
        let syntax: DeclSyntax = """
extension \(declaration.name) {
    /// Memberwise initializer.
    \(raw: accessLevel)convenience init(\(raw: properties.map { "\($0.name): \($0.type)\($0.initializerExpression != nil ? "\($0.initializerExpression!)" : "")" }.joined(separator: ",\n                            "))) {
        \(raw: properties.map { "self.\($0.name) = \($0.name)" }.joined(separator: "\n        "))
    }
}
"""
        
        return syntax.as(ExtensionDeclSyntax.self)
    }
}
