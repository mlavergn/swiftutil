/// App struct with package or bundle related helpers
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

import Foundation

// MARK: - App struct
public struct APNS {

	/// Make APNS token data a human readable hex string
	public static func deviceTokenStringify(_ deviceToken: Data) -> String {
        var deviceTokenString = ""
        for byte in deviceToken {
            deviceTokenString += String(format: "%02X", byte)
        }

        return deviceTokenString
	}
}
