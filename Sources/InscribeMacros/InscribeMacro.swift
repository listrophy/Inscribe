import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct InscribeMacro: ExtensionMacro {
    public static func expansion(
        of node: AttributeSyntax,
        attachedTo declaration: some DeclGroupSyntax,
        providingExtensionsOf type: some TypeSyntaxProtocol,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [ExtensionDeclSyntax] {
        let stringModifiers = declaration.modifiers.map(\.name.trimmedDescription)
        let maybeAccessModifier = stringModifiers.first(where: { accessModifiers.contains($0) })
        let accessModifier = maybeAccessModifier.map { "\($0) " } ?? ""

        return [try? ExtensionDeclSyntax("""
        \(raw: accessModifier)extension \(raw: type.description) {
            var description: String { "\(raw: type.description)" }
            static var description: String { "\(raw: type.description)" }
        }
        """)].compactMap(\.self)
    }

    // An `Array` is _probably_ quicker than a `Set<String>`
    private static let accessModifiers: [String] = [
        "fileprivate",
        "internal",
        "open",
        "package",
        "private",
        "public",
    ]
}

@main
struct InscribePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        InscribeMacro.self,
    ]
}
