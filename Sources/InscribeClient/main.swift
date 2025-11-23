import Inscribe

enum Parent {
    @Inscribe public final class Widget: CustomStringConvertible {}
    @InscribeSafe struct Flarble: CustomStringConvertible {
        var description: String {
            __InscribeMacro_description
        }
    }
}

let w = Parent.Widget()
let f = Parent.Flarble()

print("The Widget is described as \(w.description)")
print("The Flarble is described as \(f)")
