import UIKit

precedencegroup ApplicativePrecedence {
    associativity: left
    higherThan: NilCoalescingPrecedence
}

infix operator <*>: ApplicativePrecedence

func <*><A, B>(_ arg: A?, transform: (A) -> B) -> B? {
    return arg.map(transform)
}

func generate(from string: String, size requestedSize: CGSize) -> UIImage? {
    return CIFilter(name: "CIQRCodeGenerator").flatMap {
        codeImage(from: string, filter: $0) <*> { image(form: $0, scaledTo: requestedSize) }
    }
}

func codeImage(from string: String,
               filter: CIFilter) -> CIImage? {
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
