# Inscribe

As it turns out, `Swift(describing:)` is pretty slow, because it needs to demangle. It also results in an undefined value that you shouldn't be relying upon. There's a replacement (`_typeName`), but that's private API.

Enter `@Inscribe`:

```swift
enum Parent {
    @Inscribe public final class Widget: CustomStringConvertible {}
}

let w = Parent.Widget()

print("The Widget is described as \(w.description)")
```

The `@Inscribe` macro will, in this case, expand into:

```swift
public extension Parent.Widget {
    var description: String {
        "Parent.Widget"
    }
    static var description: String {
        "Parent.Widget"
    }
}
```

# Installation

Install with Swift Package Manager, do an `import Inscribe`, and start annotating your types!

# Areas for improvement

This macro was initially written in about half an hour. Basically, the improvements needed are (in order):

1. Access modifier is hardcoded to `public`. Instead, read the access modifier from the attached declaration.
2. The `expansion(...)` body of this macro just uses the `init(_ stringInterpolation: SyntaxNodeString)` mechanism. Build up the AST from real types instead of an interpolated string.
3. Constrain this to the types it should be constrained to.

# Contributing

Contributions are welcome! Throw me a PR, and I'll take a look.
