import Foundation

public class URLFetch {
	var urlString: String?

	// required
	public init() {
	}

	/**
	blocking
	*/
	public func fetchStringContents(_ urlString: String) -> (String, Error?) {
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
	public func fetchDataContents(_ urlString: String) -> (Data, Error?) {
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
	public func fetchDataTask(_ url: String, completionHandler:@escaping((String?) -> Void)) -> URLSessionDataTask {
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
