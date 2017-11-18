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

public enum DeviceOS: Int {
	case iOS = 0
	case macOS
	case watchOS
	case tvOS
	case other
}

// MARK: - Device struct
public struct Device {

	/// Device unique identifier as a String
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

	/// Device name as a String
	public static var name: String {
		#if os(iOS)
		return UIDevice.current.name
		#else
		guard let name = Host.current().localizedName else {
			return ""
		}
		return name
		#endif
	}

	/// OS as a DeviceOS enum
	public static var os: DeviceOS {
		#if os(iOS)
			return .iOS
		#elseif os(macOS)
			return .macOS
		#elseif os(watchOS)
			return .watchOS
		#elseif os(tvOS)
			return .tvOS
		#else
			return .other
		#endif
	}
}
