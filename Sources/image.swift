import Foundation

#if os(iOS)
import UIKit
import ImageIO
#elseif os(macOS)
import AppKit
#endif

public struct Images {

	/**
	default portrait
	*/
	public func resize<T>(image: T, width: Float = 768, height: Float = 1024) -> T? {
		// if landscape, switch up
		#if os(iOS)
		var image: UIImage = image as! UIImage
		#elseif os(macOS)
		var image: NSImage = image as! NSImage
		#endif

		var width: Float = width
		var height: Float = height

		if image.size.height < image.size.width {
			width = 1024
			height = 768
		}

		// optimal image size
		let size = CGSize(width: CGFloat(width), height: CGFloat(height))

		#if os(iOS)
		if !image.size.equalTo(size) {
			UIGraphicsBeginImageContext(size)
			image.draw(in: CGRect(x:0, y:0, width:size.width, height:size.height))
			image = UIGraphicsGetImageFromCurrentImageContext()!
			UIGraphicsEndImageContext()
		}
		#elseif os(macOS)
		#endif

		return image as? T
	}

	/**
	*/
	public func imageToData(name: String, compression: Float) -> Data? {
		var data: Data? = nil
		#if os(iOS)
			if var image = UIImage(named:name) {
				image = resize(image: image) as UIImage!
				data = UIImageJPEGRepresentation(image, CGFloat(compression))
			}
		#elseif os(macOS)
			if var image = NSImage(named:name) {
				image = resize(image: image) as NSImage!
				let imageRep = NSBitmapImageRep(data:image.tiffRepresentation!)!

				// resize to some factor (compression only)
				data = imageRep.representation(using: .JPEG, properties: [NSImageCompressionFactor: compression])
			}
		#endif

		return data
	}
}
