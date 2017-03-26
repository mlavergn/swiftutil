import Foundation

public struct URLFetch {

	// required
	public init() {
	}

	/**
	blocking
	*/
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

	/**
	blocking
	*/
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

	/**
	non-blocking
	*/
	public static func fetchDataTask(_ url: String, completionHandler:@escaping((String?) -> Void)) -> URLSessionDataTask {
		let sessionConfiguration = URLSessionConfiguration.default
		let session = URLSession(configuration: sessionConfiguration)
		let url = URL(string: url)!

		let task = session.dataTask(with: url, completionHandler: {data, response, error in
				if let d = data {
					let dataString = String(data: d, encoding: .utf8)
					completionHandler(dataString)
				}
		})

		task.resume()
		return task
	}
}
