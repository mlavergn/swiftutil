import Foundation

public extension Date {

	/**
	*/
	public func isBefore(date: Date) -> Bool {
		if self.compare(date) == .orderedAscending {
			return true
		} else {
			return false
		}
	}

	/**
	*/
	public func isAfter(date: Date) -> Bool {
		if self.compare(date) == .orderedDescending {
			return true
		} else {
			return false
		}
	}

	/**
	*/
	public func isEqual(date: Date) -> Bool {
		if self.compare(date) == .orderedSame {
			return true
		} else {
			return false
		}
	}
}

public struct DateTime {

	/**
	*/
	public static var epoch: Int {
		return Int(NSDate().timeIntervalSince1970)
	}

	/**
	*/
	public static func dateWith(year: Int, month: Int, day: Int) -> Date? {
		var components = DateComponents()
		components.year = year
		components.month = month
		components.day = day

		return NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from:components)
	}

	/**
	*/
	public static func stringToDate(format: String, date: String) -> Date? {
		let dateFormat = DateFormatter()
		dateFormat.timeZone = NSTimeZone.default
		dateFormat.dateFormat = format

		return dateFormat.date(from:date)
	}
}
