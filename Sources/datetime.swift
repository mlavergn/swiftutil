/// Extensions to Date
/// DateTime struct with Date related helpers
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

import Foundation

// MARK: - Date extension
public extension Date {

	/// Compare caller to date to caller and determine if caller is earlier
	///
	/// - Parameter date: Date to compare caller against
	/// - Returns: Bool with true if date is later than caller, otherwise false
	public func isBefore(date: Date) -> Bool {
		return self.compare(date) == .orderedAscending ? true : false
	}

	/// Compare caller to date to caller and determine if caller is later
	///
	/// - Parameter date: Date to compare caller against
	/// - Returns: Bool with true if date is earlier than caller, otherwise false
	public func isAfter(date: Date) -> Bool {
		return self.compare(date) == .orderedDescending ? true : false
	}

	/// Compare caller to date to caller and determine if caller is equal
	///
	/// - Parameter date: Date to compare caller against
	/// - Returns: Bool with true if date is equal to caller, otherwise false
	public func isEqual(date: Date) -> Bool {
		return self.compare(date) == .orderedSame ? true : false
	}
}

// MARK: - DateTime struct
public struct DateTime {

	/// Obtain the epoch time as an Int
	public static var epoch: Int {
		return Int(NSDate().timeIntervalSince1970)
	}

	/// Constructs a Date object based on the Gregorian calendar
	///
	/// - Parameters:
	///   - year: year as an Int
	///   - month: month as an Int
	///   - day: day as an Int
	/// - Returns: Date optional
	public static func dateWith(year: Int, month: Int, day: Int) -> Date? {
		var components = DateComponents()
		components.year = year
		components.month = month
		components.day = day

		return NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: components)
	}

	/// Constructs a Date from a format mask and string representation
	///
	/// - Parameters:
	///   - format: format mask String
	///   - date: date as String
	/// - Returns: Date optional
	public static func stringToDate(format: String, date: String) -> Date? {
		let dateFormat = DateFormatter()
		dateFormat.timeZone = NSTimeZone.default
		dateFormat.dateFormat = format

		return dateFormat.date(from: date)
	}
}
