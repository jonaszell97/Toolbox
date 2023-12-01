
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct macrotestPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AutomaticConformancesMacro.self,
    ]
}
