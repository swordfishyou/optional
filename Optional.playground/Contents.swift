import UIKit

func generate(from string: String, size requestedSize: CGSize) -> UIImage? {
    return CIFilter(name: "CIQRCodeGenerator").flatMap {
        $0.setValue(string.data(using: String.Encoding.ascii), forKey: "inputMessage")
        return $0.outputImage.map {
            let transform = scaleTransform(from: $0.extent.size, to: requestedSize)
            return UIImage(ciImage: $0.transformed(by: transform))
        }
    }
}

func scaleTransform(from originalSize: CGSize,
                    to requestedSize: CGSize) -> CGAffineTransform {
    let scaleX = requestedSize.width / originalSize.width
    let scaleY = requestedSize.height / originalSize.height
    return CGAffineTransform(scaleX: scaleX, y: scaleY)
}
