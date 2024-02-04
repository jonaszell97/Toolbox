
/// Automatically generate conformances to various protocols for a type.
/// 
/// This macro generates conformances to `Equatable`, `Hashable`, `Codable`, and `CustomStringConvertible` 
/// for a struct, class, or enum type. It can also generate a memberwise initializer for struct or class types.
/// 
/// It is currently not possible to exclude certain properties from the generated conformances.
@attached(extension, conformances: Equatable, Hashable, Codable, CustomStringConvertible, names: arbitrary)
public macro DeriveConformances(types: [String]) = #externalMacro(module: "ToolboxMacros", type: "AutomaticConformancesMacro")
