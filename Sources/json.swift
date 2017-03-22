import Foundation

public struct JSON {

	/**
	*/
	public static func decode(_ payload: Data) -> Any? {
		do {
			return try JSONSerialization.jsonObject(with:payload, options: .mutableContainers)
		} catch {
			return nil
		}
	}

	/**
	*/
	public static func encode(_ object: Any) -> Data? {
		do {
			return try JSONSerialization.data(withJSONObject:object, options:[])
		} catch {
			return nil
		}
	}

	/**
	*/
	public static func decodeFromString(_ payload: String) -> [String: AnyObject]? {
		if let raw = self.decode(payload.data!) {
			if let result: Dictionary = raw as? [String: AnyObject] {
				return result
			}
		}

		return nil
	}

	/**
	*/
	public static func encodeAsString(_ object: Any) -> String? {
		return String(data:self.encode(object)!)
	}
}
