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
        [try? ExtensionDeclSyntax("""
        public extension \(raw: type.description) {
            var description: String { "\(raw: type.description)" }
            static var description: String { "\(raw: type.description)" }
        }
        """)].compactMap(\.self)
    }
}

@main
struct InscribePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        InscribeMacro.self,
    ]
}
