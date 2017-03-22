import Foundation

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public struct Images {

	/**
	*/
	public func imageToData(name: String) -> Data? {
		#if os(iOS)
			let image = UIImage(named:name)
			let data = UIImagePNGRepresentation(image)
		#elseif os(macOS)
			let image = NSImage(named:name)!
			let imageRep = NSBitmapImageRep(data:image.tiffRepresentation!)!

			// resize to some factor
			let props = [NSImageCompressionFactor: 0.9]
			let data = imageRep.representation(using: .PNG, properties: props)
		#endif

		return data
	}
}
