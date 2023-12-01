
import SwiftSyntax
import SwiftSyntaxMacros

func getStringArguments(node: AttributeSyntax) -> Set<String>? {
    guard let arguments = node.arguments else {
        return nil
    }
    
    var result = Set<String>()
    for argument in arguments.children(viewMode: .all) {
        guard let labeledExpr = argument.as(LabeledExprSyntax.self) else {
            continue
        }
        guard let labelSyntax = labeledExpr.label?.tokenKind, case .identifier(let str) = labelSyntax, str == "types" else {
            continue
        }
        
        guard let arrayExpr = labeledExpr.expression.as(ArrayExprSyntax.self) else {
            continue
        }
        
        for element in arrayExpr.elements {
            guard let elementExpr = element.as(ArrayElementListSyntax.Element.self) else {
                continue
            }
            guard let stringExpr = elementExpr.expression.as(StringLiteralExprSyntax.self) else {
                continue
            }
            guard stringExpr.segments.count == 1, let first = stringExpr.segments.first else {
                continue
            }
            guard let string = first.as(StringSegmentSyntax.self) else {
                continue
            }
            
            result.insert(string.content.text)
        }
    }
    
    return result
}

func getAccessModifier(for declaration: DeclModifierListSyntax) -> String {
    for modifier in declaration {
        guard case .keyword(let keyword) = modifier.name.tokenKind else {
            continue
        }
        
        if keyword == .public {
            return "public "
        }
    }
    
    return ""
}

struct PropertyDeclaration {
    let name: IdentifierPatternSyntax
    let type: TypeSyntax
    var initializerExpression: InitializerClauseSyntax?
}

func getPropertyDeclarations(of declaration: MemberBlockSyntax) -> [PropertyDeclaration] {
    var result = [PropertyDeclaration]()
    for member in declaration.members {
        guard let variableDecl = member.decl.as(VariableDeclSyntax.self) else {
            continue
        }
        
        for binding in variableDecl.bindings {
            guard let identifier = binding.pattern.as(IdentifierPatternSyntax.self) else {
                continue
            }
            guard let type = binding.typeAnnotation else {
                continue
            }
            
            result.append(.init(name: identifier, type: type.type, initializerExpression: binding.initializer))
        }
    }
    
    return result
}

struct EnumParameterDeclaration {
    let name: TokenSyntax?
    let label: String
    let type: TypeSyntax
    let initializerExpression: InitializerClauseSyntax?
}

struct EnumCaseDeclaration {
    let name: TokenSyntax
    let parameters: [EnumParameterDeclaration]
}

func getEnumCaseDeclarations(of declaration: EnumDeclSyntax) -> [EnumCaseDeclaration] {
    var result = [EnumCaseDeclaration]()
    for member in declaration.memberBlock.members {
        guard let enumCase = member.decl.as(EnumCaseDeclSyntax.self) else {
            continue
        }
        
        for element in enumCase.elements {
            var parameters = [EnumParameterDeclaration]()
            if let parameterClause = element.parameterClause {
                for parameter in parameterClause.parameters {
                    let name = parameter.secondName ?? parameter.firstName
                    
                    var label: String = ""
                    if case .identifier(let id) = parameter.firstName?.tokenKind {
                        label = "\(id): "
                    }
                    
                    parameters.append(.init(name: name, label: label, type: parameter.type, initializerExpression: parameter.defaultValue))
                }
            }
            
            result.append(.init(name: element.name, parameters: parameters))
        }
    }
    
    return result
}
