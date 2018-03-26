/// HTTP subclass with FORM multipart functionality
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

import Foundation

// MARK: - HTTPMulti object
public class HTTPMulti: HTTP {

	private var _boundary: String?

	public var boundary: String {
		guard let boundary = self._boundary else {
			self._boundary = "WebKitFormBoundary"  + UUID().uuidString.substring(from: -12)
			return self._boundary!
		}

		return boundary
	}

	public func addTextPart(name: String, text: String) {
		Log.stamp()
		if self.postData == nil {
			self.postData = Data()
		}

		let marker = "\r\n--\(self.boundary)\r\nContent-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
		self.postData!.appendString(marker)
		self.postData!.appendString(text)
	}

	public func addBinaryPart(name: String, filename: String, binary: Data) {
		Log.stamp()
		if self.postData == nil {
			self.postData = Data()
		}

		let marker: String = "\r\n--\(self.boundary)\r\nContent-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n" +
		"\(HTTPHeaderKey.contentType.rawValue): \(HTTPMIMEKey.bin.rawValue)\r\n\r\n"
		self.postData!.appendString(marker)
		self.postData!.append(binary)
	}

	public func addJSONPart(name: String, json: [String: Any]) {
		Log.stamp()
		if self.postData == nil {
			self.postData = Data()
		}

		if let jsonString = JSON.encodeAsString(json) {
			let marker = "\r\n--\(self.boundary)\r\nContent-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
			self.postData!.appendString(marker)
			self.postData!.appendString(jsonString)
		}
	}

	public func postMultiPart(urlString: String) -> [AnyHashable: Any] {
		Log.stamp()
		self.urlString = urlString

		self.method = .post

		let mpType = HTTPMIMEKey.form.rawValue + "; boundary=" + self.boundary
		self.request.setValue(mpType, forHTTPHeaderField: HTTPHeaderKey.contentType.rawValue)

		if self.postData == nil {
			self.postData = Data()
		}

		let marker = "\r\n--\(self.boundary)\r\n"
		self.postData!.appendString(marker)

		let cLen = String(self.contentLength)
		self.request.setValue(cLen, forHTTPHeaderField: HTTPHeaderKey.contentLength.rawValue)

		var result: [AnyHashable: Any]? = nil
		let cndlock = NSConditionLock(condition: 0)

		let uploadTask = session.uploadTask(with: request, from: self.postData!) { (data: Data?, response: URLResponse?, err: Error?) in
			cndlock.lock()
			defer {cndlock.unlock(withCondition: 1)}
			if let error = err {
				Log.error(error)
				result = [:]
			} else {
                Log.debug(response?.expectedContentLength)
				if let data = data {
					result = JSON.decodeData(data)
					Log.debug(result)
				}
			}
		}
		uploadTask.resume()
		cndlock.lock(whenCondition: 1, before: NSDate.distantFuture)
		cndlock.unlock(withCondition: 0)

		return result!
	}
}
