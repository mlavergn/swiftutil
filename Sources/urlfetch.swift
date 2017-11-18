/// URLFetch struct with canned fetch helpers
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

import Foundation

public struct URLFetch {

	/// Blocking fetch of String content at the given url String
	///
	/// - Parameter urlString: url as a String
	/// - Returns: Tuple containing String with contents and optional Error
	public static func fetchStringContents(_ urlString: String) -> (String, Error?) {
		if let url = URL(string:urlString) {
			do {
				let contents: String = try String(contentsOf:url)
				return (contents, nil)
			} catch {
				return ("", error)
			}
		}
		return ("", NSError.error("invalid URL"))
	}

	/// Blocking fetch of Data content at the given url String
	///
	/// - Parameter urlString: url as a String
	/// - Returns: Tuple containing Data with contents and optional Error
	public static func fetchDataContents(_ urlString: String) -> (Data, Error?) {
		if let url = URL(string:urlString) {
			do {
				let contents = try Data(contentsOf:url)
				return (contents, nil)
			} catch {
				return (Data(), error)
			}
		}
		return (Data(), NSError.error("invalid URL"))
	}

	/// Non-blocking fetch of content at the given url String
	///
	/// - Parameters:
	///   - urlString:  url as a String
	///   - completionHandler: completion handler taking an optional String as a parameter, returning Void
	/// - Returns: URLSessionDataTask in use
	public static func fetchDataTask(_ urlString: String, completionHandler:@escaping((String?) -> Void)) -> URLSessionDataTask {
		let sessionConfiguration = URLSessionConfiguration.default
		let session = URLSession(configuration: sessionConfiguration)
		let url = URL(string: urlString)!

		let task = session.dataTask(with: url, completionHandler: {data, response, error in
            if let error = error {
                Log.error(error)
                return
            }
            if let d = data {
                Log.debug(response?.expectedContentLength)
                let dataString = String(data: d, encoding: .utf8)
                completionHandler(dataString)
            }
		})

		task.resume()
		return task
	}
}
