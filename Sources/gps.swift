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

		CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, err) in
			Log.stamp()
            if let err = err {
                Log.error(err)
                return
            }

			guard placemarks != nil else {
				return
			}

			if let addrDict = self.safeAddressDictionary(placemarks: placemarks) {
				if let zip = self.safeAddressDictionaryLookup(addressDictionary: addrDict, key: "ZIP") {
					result = zip
					if let countryCode = self.safeAddressDictionaryLookup(addressDictionary: addrDict, key: "CountryCode") {
						if countryCode == "CA" {
							// we get the forward sortation are only, so tack the primary local delivery unit 
							result.append("0A0")
						}
					}
					self.deactivateLocationManager()
				}
			}

			Log.debug(result)
		})

		return result
	}

	/// Wrapped for AddressDictionary extraction
	///
	/// - Parameter placemarks: CLPlacemarks array
	/// - Returns: AddressDictionary from CLPlacemark at index 0
	private func safeAddressDictionary(placemarks: [CLPlacemark]?) -> [AnyHashable : Any]? {
		guard placemarks != nil else {
			return nil
		}

		let placemark = placemarks![0]
		if let addressDictionary = placemark.addressDictionary {
			return addressDictionary
		}

		return nil
	}

	/// Wrapped for AddressDictionary lookups
	///
	/// - Parameters:
	///   - addressDictionary: address dictionary from CLPlacemark
	///   - key: key within dictionary
	/// - Returns: String optional with value
	private func safeAddressDictionaryLookup(addressDictionary: [AnyHashable : Any], key: String) -> String? {
		if let result = addressDictionary[key] {
			return result as? String
		}

		return nil
	}
}
