/// App struct with package or bundle related helpers
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

#if os(iOS) || os(tvOS)
import UIKit
import UserNotifications
#else
import AppKit
#endif

// MARK: - App struct
public struct APNS {

	#if os(iOS) || os(tvOS)
	public static func requestAuthoriztion() {
		let center = UNUserNotificationCenter.current()
		center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
			if granted {
				print("Allow")
				UIApplication.shared.registerForRemoteNotifications()
			} else {
				print("Don't Allow")
			}
		}
	}
	#else
	func requestAuthoriztion() {
		NSApp.registerForRemoteNotifications(matching: .badge)
	}
	#endif

	/// Make APNS token data a human readable hex string
	/// call at UIApplication::didRegisterForRemoteNotificationsWithDeviceToken
	public static func deviceTokenStringify(_ deviceToken: Data) -> String {
		let deviceTokenString: String = deviceToken.reduce("", {$0.appendingFormat("%02X", $1)})
        return deviceTokenString
	}

	/// call from UIApplication::didFailToRegisterForRemoteNotificationsWithError
	func failedToRegisterWithError(error: Error) {
		print(error)
	}

	/// call from UIApplication::didReceiveRemoteNotification
	func didReceiveRemoteNotification(userInfo: [AnyHashable : Any]) {
		print(userInfo)
	}

	/// send token to provider
	func sendTokenToProvider() {
		// send it somewhere
	}
}
