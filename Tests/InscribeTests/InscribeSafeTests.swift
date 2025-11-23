import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(InscribeMacros)
import InscribeMacros
#endif

final class InscribeSafeTests: XCTestCase {
#if canImport(InscribeMacros)
    let testMacros: [String: Macro.Type] = [
        "InscribeSafe": InscribeSafeMacro.self,
    ]

    func testMacro() throws {
        assertMacroExpansion(
            """
            @InscribeSafe public final class Foo {}
            """,
            expandedSource: """
            public final class Foo {}

            public extension Foo {
                var __InscribeMacro_description: String {
                    "Foo"
                }
                static var __InscribeMacro_description: String {
                    "Foo"
                }
            }
            """,
            macros: testMacros
        )
    }

    func testMacroOnNestedType() throws {
        assertMacroExpansion(
            """
            public enum GrandParent {
                public enum Parent {
                    @InscribeSafe public final class Child {}
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
                var __InscribeMacro_description: String {
                    "GrandParent.Parent.Child"
                }
                static var __InscribeMacro_description: String {
                    "GrandParent.Parent.Child"
                }
            }
            """,
            macros: testMacros
        )
    }

    func testMacroExplicitAccessModifier() throws {
        assertMacroExpansion(
            """
            public enum GrandParent {
                public enum Parent {
                    @InscribeSafe private final class Child {}
                }
            }
            """,
            expandedSource: """
            public enum GrandParent {
                public enum Parent {
                    private final class Child {}
                }
            }

            private extension GrandParent.Parent.Child {
                var __InscribeMacro_description: String {
                    "GrandParent.Parent.Child"
                }
                static var __InscribeMacro_description: String {
                    "GrandParent.Parent.Child"
                }
            }
            """,
            macros: testMacros
        )
    }

    func testMacroImplicitAccessModifier() throws {
        assertMacroExpansion(
            """
            public enum GrandParent {
                enum Parent {
                    @InscribeSafe final class Child {}
                }
            }
            """,
            expandedSource: """
            public enum GrandParent {
                enum Parent {
                    final class Child {}
                }
            }

            extension GrandParent.Parent.Child {
                var __InscribeMacro_description: String {
                    "GrandParent.Parent.Child"
                }
                static var __InscribeMacro_description: String {
                    "GrandParent.Parent.Child"
                }
            }
            """,
            macros: testMacros
        )
    }
#endif
}
