/// Device struct with hardware related helpers
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT
import Foundation

#if os(iOS)
import UIKit
#else
import IOKit
#endif

// MARK: - Device struct
public struct Device {

	/// Device unique identifier
	public static var deviceId: String {
		Log.stamp()
		var id: String = ""
		#if os(iOS)
		if let serial = UIDevice.current.identifierForVendor?.uuidString {
			id = serial
		}
		#else
		let platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice") )
		if let serial = (IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0).takeUnretainedValue() as? String) {
			id = serial
		}
		IOObjectRelease(platformExpert)
		#endif

		return id
	}
}
