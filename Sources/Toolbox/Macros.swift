
@attached(extension, conformances: Equatable, Hashable, Codable, CustomStringConvertible, names: arbitrary)
public macro DeriveConformances(types: [String]) = #externalMacro(module: "ToolboxMacros", type: "AutomaticConformancesMacro")
