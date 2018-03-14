/// GPS struct with location related helpers
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

import CoreLocation

// MARK: - GPS class
public class GPS: NSObject, CLLocationManagerDelegate {
	let locationManager = CLLocationManager()
	var coordinates = CLLocationCoordinate2D()
	var requests = 0

	/// Starts the location manager updates
	private func activateLocationManager() {
		Log.stamp()

		if requests == 0 {
			requests += 1
			// Ask for Authorisation from the User.
			// self.locationManager.requestAlwaysAuthorization()

			// For use in foreground
			#if os(iOS)
			self.locationManager.requestWhenInUseAuthorization()
			#endif

			if CLLocationManager.locationServicesEnabled() {
				locationManager.delegate = self
				locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
				locationManager.startUpdatingLocation()
			}
		}
	}

	/// Stops the location manager updates
	private func deactivateLocationManager() {
		Log.stamp()
		self.requests -= 1
		if self.requests == 0 {
			self.locationManager.stopUpdatingLocation()
		}
	}

	/// Delegate method
	public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		Log.stamp()
		Log.debug(status.rawValue)

		if status == .notDetermined {
			#if os(iOS)
			self.locationManager.requestWhenInUseAuthorization()
			#endif
		}
	}

	/// Delegate method
	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		Log.stamp()
		self.coordinates = manager.location!.coordinate
		Log.debug(self.zipCode)
	}

	/// Obtains the device location ZIP code as a String
	/// NOTE: Supports US and Canada cleanly.
	public var zipCode: String {
		self.activateLocationManager()

		let location = CLLocation.init(latitude: coordinates.latitude, longitude: coordinates.longitude)
		var result = ""

		CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
			Log.stamp()
            if let error = error {
                Log.error(error)
                return
            }

			guard let placemark = placemarks?.first else {
				return
			}

			if #available(iOS 11, macOS 10.13, *) {
                if let zip = placemark.postalCode {
                    result = zip
                }
			} else {
				if let addrDict = placemark.addressDictionary {
					if let zip = addrDict["ZIP"] as? String {
						result = zip
						if let countryCode = addrDict["CountryCode"] as? String {
							if countryCode == "CA" {
								// we get the forward sortation are only, so tack the primary local delivery unit 
								result.append("0A0")
							}
						}
						self.deactivateLocationManager()
					}
				}
			}

			Log.debug(result)
		})

		return result
	}
}
