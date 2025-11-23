@attached(extension, names: named(description))
public macro Inscribe() = #externalMacro(module: "InscribeMacros", type: "InscribeMacro")

@attached(extension, names: named(__InscribeMacro_description))
public macro InscribeSafe() = #externalMacro(module: "InscribeMacros", type: "InscribeSafeMacro")
