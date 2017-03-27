/// JSON struct with JSON helpers
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT
import Foundation

public struct JSON {

	/// Decodes a Data payload into a Swift object type
	///
	/// - Parameter payload: payload of type Data
	/// - Returns: Any optional
	public static func decode(_ payload: Data) -> Any? {
		do {
			return try JSONSerialization.jsonObject(with:payload, options: .mutableContainers)
		} catch {
			return nil
		}
	}

	/// Encodes a Swift object type into a Data payload
	///
	/// - Parameter object: Any object
	/// - Returns: Data optional
	public static func encode(_ object: Any) -> Data? {
		do {
			return try JSONSerialization.data(withJSONObject:object, options:[])
		} catch {
			return nil
		}
	}

	/// Decodes a Data payload into a Dictionary
	///
	/// - Parameter payload: payload of type Data
	/// - Returns: Any optional
	public static func decodeData(_ payload: Data) -> [String: AnyObject]? {
		return self.decode(payload) as? [String: AnyObject]
	}

	/// Encodes a dictionary into a Data payload
	///
	/// - Parameter object: Any object
	/// - Returns: Data optional
	public static func encodeAsData(_ object: Any) -> Data? {
		return self.encode(object)
	}

	/// Decodes a String payload into a Swift object type
	///
	/// - Parameter payload: payload of type String
	/// - Returns: Dictionary with String keys and AnyObject values
	public static func decodeString(_ payload: String) -> [String: AnyObject]? {
		return self.decodeData(payload.data!)
	}

	/// Encodes a Swift object type into a String payload
	///
	/// - Parameter object: Any object
	/// - Returns: String optional
	public static func encodeAsString(_ object: Any) -> String? {
		return String(data:self.encode(object)!)
	}
}
