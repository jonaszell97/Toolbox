
@attached(member, names: arbitrary)
@attached(extension)
public macro DeriveConformances(types: [String]) = #externalMacro(module: "ToolboxMacros", type: "AutomaticConformancesMacro")
