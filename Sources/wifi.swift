/// Wifi struct with wifi related helpers
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

import Foundation
import SystemConfiguration.CaptiveNetwork
#if os(macOS)
import CoreWLAN
#endif

// FIX: Define a common struct for SSID info

// MARK: - Wifi struct
public struct Wifi {
	public static func ssids() -> [String] {
		var ssids: [String] = []
#if os(iOS) || os(tvOS)
		guard let ifs = CNCopySupportedInterfaces() as? [String] else {
			Log.error("Could not access network interfaces")
			return ssids
		}

		for interface in ifs {
			if let ssidMap = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: AnyObject] {
				for d in ssidMap.keys {
					print("\(d): \(ssidMap[d]!)\n")
					ssids.append(d)
				}
			}
		}
#elseif os(macOS)
		let wifi = CWWiFiClient.shared().interface()
		do {
			guard let ssidSet = try wifi?.scanForNetworks(withSSID: nil) else {
				return ssids
			}

			for entry in ssidSet {
				if let ssid = entry.ssid {
					ssids.append(ssid)
				}
			}
		} catch {
			Log.error("Could not access SSIDs")
		}
#endif

		return ssids
	}
}
