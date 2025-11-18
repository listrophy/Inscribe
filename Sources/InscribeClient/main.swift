import Inscribe

enum Parent {
    @Inscribe public final class Widget: CustomStringConvertible {}
}

let w = Parent.Widget()

print("The Widget is described as \(w.description)")
