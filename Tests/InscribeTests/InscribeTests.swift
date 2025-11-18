import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(InscribeMacros)
import InscribeMacros

let testMacros: [String: Macro.Type] = [
    "Inscribe": InscribeMacro.self,
]
#endif

final class InscribeTests: XCTestCase {
    func testMacro() throws {
        #if canImport(InscribeMacros)
        assertMacroExpansion(
            """
            @Inscribe public final class Foo {}
            """,
            expandedSource: """
            public final class Foo {}

            public extension Foo {
                var description: String {
                    "Foo"
                }
                static var description: String {
                    "Foo"
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMacroOnNestedType() throws {
        #if canImport(InscribeMacros)
        assertMacroExpansion(
            """
            public enum GrandParent {
                public enum Parent {
                    @Inscribe public final class Child {}
                }
            }
            """,
            expandedSource: """
            public enum GrandParent {
                public enum Parent {
                    public final class Child {}
                }
            }

            public extension GrandParent.Parent.Child {
                var description: String {
                    "GrandParent.Parent.Child"
                }
                static var description: String {
                    "GrandParent.Parent.Child"
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
