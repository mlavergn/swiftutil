import Foundation

#if os(iOS)
import UIKit
import ImageIO
#elseif os(macOS)
import AppKit
#endif

public struct Images {

	/**
	*/
	public func imageToData(name: String) -> Data? {
		#if os(iOS)
			var data: Data? = nil
			if let image = UIImage(named:name) {
				
				if image.size.height > image.size.width {
					
				}
				CGSizeMake(width, height)
				if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
						UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
					} else {
						UIGraphicsBeginImageContext(size);
					}
					[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
					UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
					UIGraphicsEndImageContext();
					
				// resize to some factor (compression only)
				if var data = UIImageJPEGRepresentation(image, 0.7) {
					let mdata:NSMutableData = NSMutableData(data: data)
					let cgi: CGImageDestination = CGImageDestinationCreateWithData(mdata as CFMutableData, .JPEG, 1, nil)
					CGImageDestinationSetProperties(cgi, [kCGImageDestinationLossyCompressionQuality: 0.7] as CFDictionary)
//				let imageRep = UIBitmapImageRep(data:image.tiffRepresentation!)!
				
					let data = imageRep.representation(using: .JPEG, properties: props)
				}
			}
		#elseif os(macOS)
			let image = NSImage(named:name)!
			let imageRep = NSBitmapImageRep(data:image.tiffRepresentation!)!

			// resize to some factor (compression only)
			let props = [NSImageCompressionFactor: 0.7]
			let data = imageRep.representation(using: .JPEG, properties: props)
		#endif

		return data
	}
}
