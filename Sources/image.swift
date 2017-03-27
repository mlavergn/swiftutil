/// Images struct image related helpers
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT
import Foundation

#if os(iOS)
import UIKit
import ImageIO
#elseif os(macOS)
import AppKit
import Cocoa
#endif

public struct Images {

	#if os(macOS)
	/// Resize image to the given width height
	///
	/// - Parameters:
	///   - image: image to resize as NSImage
	///   - width: target width of the image as a Float
	///   - height: target height of the image as a Float
	/// - Returns: resized NSImage
	public static func resize(image: NSImage, width: Float = 768, height: Float = 1024) -> NSImage {
		var sizedImage: NSImage = image

		// if landscape, switch up
		var width: Float = width
		var height: Float = height

		if image.size.height < image.size.width {
			width = 1024
			height = 768
		}

		// optimal image size
		let size = CGSize(width: CGFloat(width), height: CGFloat(height))

		if !image.size.equalTo(size) {
			sizedImage = NSImage(size:size)
			sizedImage.lockFocus()

			let rect = CGRect(origin:CGPoint.zero, size:size)
			image.draw(in:rect, from:NSRect.zero, operation:NSCompositeSourceOver, fraction:1.0)

			sizedImage.unlockFocus()
		}

		return sizedImage
	}
	#endif

	#if os(iOS)
	/// Resize image to the given width height
	///
	/// - Parameters:
	///   - image: image to resize as UIImage
	///   - width: target width of the image as a Float
	///   - height: target height of the image as a Float
	/// - Returns: resized UIImage
	public static func resize(image: UIImage, width: Float = 768, height: Float = 1024) -> UIImage {
		var sizedImage: UIImage = image
		// if landscape, switch up
		var width: Float = width
		var height: Float = height

		if image.size.height < image.size.width {
			width = 1024
			height = 768
		}

		// optimal image size
		let size = CGSize(width: CGFloat(width), height: CGFloat(height))

		if !image.size.equalTo(size) {
			UIGraphicsBeginImageContext(size)
			image.draw(in: CGRect(x:0, y:0, width:size.width, height:size.height))
			sizedImage = UIGraphicsGetImageFromCurrentImageContext()!
			UIGraphicsEndImageContext()
		}

		return sizedImage
	}
	#endif

	/// Obtain the JPEG Data of the image in the current bundle
	/// - todo: this is pretty useless as is, should pull from PhotoKit / MediaLibrary
	///
	/// - Parameters:
	///   - name: image name as String
	///   - compression: compression factor for JPEG
	/// - Returns: Data optional with JPEG representaiton
	public static func imageToData(name: String, compression: Float) -> Data? {
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
