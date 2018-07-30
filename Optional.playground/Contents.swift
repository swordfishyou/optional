import UIKit

func curry<A, B, C>(_ function: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { argA in { argB in function(argA, argB) } }
}

precedencegroup ApplicativePrecedence {
    associativity: left
    higherThan: NilCoalescingPrecedence
}

infix operator <*>: ApplicativePrecedence
func <*><A, B>(_ transform: ((A) -> B)?, arg: A?) -> B? {
    return transform.flatMap { arg.map($0) }
}

precedencegroup BindingPrecedence {
    associativity: left
    higherThan: ApplicativePrecedence
}

infix operator ??=: BindingPrecedence
func ??=<A, B>(_ transform: ((A) -> B?)?, arg: A?) -> B? {
    return transform.flatMap { arg.flatMap($0) }
}

func generate(from string: String, size requestedSize: CGSize) -> UIImage? {
    return curry(image) <*> curry(codeImage) ??= CIFilter(name: "CIQRCodeGenerator") ??= string <*> requestedSize
}

func codeImage(from filter: CIFilter,
               string: String) -> CIImage? {
    filter.setValue(string.data(using: String.Encoding.ascii), forKey: "inputMessage")
    return filter.outputImage
}

func image(form image: CIImage,
           scaledTo size: CGSize) -> UIImage {
    let transform = scaleTransform(from: image.extent.size, to: size)
    return UIImage(ciImage: image.transformed(by: transform))
}

func scaleTransform(from originalSize: CGSize,
                    to requestedSize: CGSize) -> CGAffineTransform {
    let scaleX = requestedSize.width / originalSize.width
    let scaleY = requestedSize.height / originalSize.height
    return CGAffineTransform(scaleX: scaleX, y: scaleY)
}
