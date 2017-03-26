import Foundation

public class JSONTask {

	/**
	*/
	public func upload(url: String, json: [String: Any]) {
		let sessionConfiguration = URLSessionConfiguration.default

		let session = URLSession(configuration:sessionConfiguration)

		let url = URL(string:url)
		var request = URLRequest(url:url!)

		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")

		request.httpMethod = "POST"

		//	[multipartFormData addFile:data2 parameterName:@"file2" filename:@"myimage2.png" contentType:@"image/png"];

		let postData = JSON.encode(json)
		let uploadTask = session.uploadTask(with: request, from: postData!)

		uploadTask.resume()
	}

	/**
	*/
	public func fetch(url: String) -> Any {
		let sessionConfiguration = URLSessionConfiguration.default

		let session = URLSession(configuration:sessionConfiguration)

		let url = URL(string:url)
		var request = URLRequest(url:url!)

		request.httpMethod = "GET"

		var result: Any? = nil
		let cndlock = NSConditionLock(condition: 0)

		let downloadTask = session.downloadTask(with: request) { (url: URL?, response: URLResponse?, err: Error?) in
			if let url = url {
				print(url.absoluteString as String!)
				let payload = URLFetch.fetchDataContents(url.absoluteString)
				result = JSON.decode(payload.0)
			}
			cndlock.unlock(withCondition: 1)
		}
		downloadTask.resume()
		cndlock.lock(whenCondition:1)

		return result!
	}
}
