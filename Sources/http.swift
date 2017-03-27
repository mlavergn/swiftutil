/// HTTP struct with common task helpers
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT
import Foundation

public struct HTTP {

	/**
	*/
	public static func postJSON(url: String, json: [String: Any]) {
		let sessionConfiguration = URLSessionConfiguration.default

		let session = URLSession(configuration:sessionConfiguration)

		let url = URL(string:url)
		var request = URLRequest(url:url!)

		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")

		request.httpMethod = "POST"

		//	[multipartFormData addFile:data2 parameterName:@"file2" filename:@"myimage2.png" contentType:@"image/png"];

		let postData = JSON.encodeAsData(json)
		let uploadTask = session.uploadTask(with: request, from: postData!)

		uploadTask.resume()
	}

	/// Description
	///
	/// - Parameter url: <#url description#>
	/// - Returns: <#return value description#>
	public static func getJSON(url: String) -> [String: Any] {
		let sessionConfiguration = URLSessionConfiguration.default

		let session = URLSession(configuration:sessionConfiguration)

		let url = URL(string:url)
		var request = URLRequest(url:url!)

		request.httpMethod = "GET"

		var result: [String: AnyObject]? = nil
		let cndlock = NSConditionLock(condition: 0)

		let downloadTask = session.downloadTask(with: request) { (url: URL?, response: URLResponse?, err: Error?) in
			if let url = url {
				print(url.absoluteString as String!)
				let payload = URLFetch.fetchDataContents(url.absoluteString)
				result = JSON.decodeData(payload.0)
			}
			cndlock.unlock(withCondition: 1)
		}
		downloadTask.resume()
		cndlock.lock(whenCondition:1)

		return result!
	}
}
