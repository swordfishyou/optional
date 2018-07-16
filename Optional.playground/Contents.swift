import UIKit

func generate(from string: String, size requestedSize: CGSize) -> UIImage? {
    guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
    filter.setValue(string.data(using: String.Encoding.ascii), forKey: "inputMessage")
    guard let image = filter.outputImage else { return nil }
    let transform = scaleTransform(from: image.extent.size, to: requestedSize)
    return UIImage(ciImage: image.transformed(by: transform))
}

func scaleTransform(from originalSize: CGSize,
                    to requestedSize: CGSize) -> CGAffineTransform {
    let scaleX = requestedSize.width / originalSize.width
    let scaleY = requestedSize.height / originalSize.height
    return CGAffineTransform(scaleX: scaleX, y: scaleY)
}
