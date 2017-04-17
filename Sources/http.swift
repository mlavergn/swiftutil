/// HTTP class with HTML and JSON functionality
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT
import Foundation

/// HTTP Methods
///
/// - post: POST method
/// - get: GET method
public enum HTTPMethodKey: String {
	case post    = "POST"
	case get     = "GET"
}

/// HTTP Content-Types
///
/// - json: JSON content
/// - html: HTML content
/// - text: Plain text content
/// - bin: Binary content
/// - form: Multipart form content
public enum HTTPMIMEKey: String {
	case json    = "application/json"
	case html    = "text/html"
	case text    = "text/plain"
	case bin     = "application/octet-stream"
	case form    = "multipart/form-data"
	case jpg     = "image/jpeg"
}

/// HTTP Headers
///
/// - host: Host header
/// - contentType: Content-Type header
/// - contentLength: Content-Length header
/// - accept: Accept header
/// - acceptLanguage: Accept-Language header
/// - acceptEncoding: Accept-Encoding header
/// - userAgent: User-Agent header
/// - contentEncoding: Content-Transfer-Encoding header
public enum HTTPHeaderKey: String {
	case host               = "Host"
	case contentType        = "Content-Type"
	case contentLength      = "Content-Length"
	case accept             = "Accept"
	case acceptLanguage     = "Accept-Language"
	case acceptEncoding     = "Accept-Encoding"
	case userAgent          = "User-Agent"
	case contentEncoding    = "Content-Transfer-Encoding"
}

/// User Agent Strings
///
/// - iOS: iOS user agent
/// - android: Android user agent
/// - macOS: Mac OS user agent
/// - windows: Chrome on Windows user agent
public enum HTTPUserAgentKey: String {
	case iOS      = "Mozilla/5.0 (iPhone; CPU iPhone OS 10_0 like Mac OS X) AppleWebKit/602.1.38 (KHTML, like Gecko) Version/10.0 Mobile/14A300 Safari/602.1"
	case android  = "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 6P Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.83 Mobile Safari/537.36"
	case macOS    = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30"
	case windows  = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"
}

// MARK: - HTTP object
public class HTTP: NSObject {
	internal var sessionConfiguration: URLSessionConfiguration
	public var session: URLSession
	internal var request: URLRequest
	public var postData: Data?

	/// Primary initializer
	override public init() {
		self.sessionConfiguration = URLSessionConfiguration.default
		self.session = URLSession(configuration:sessionConfiguration)
		self.request = URLRequest(url:URL(string:"http://127.0.0.2")!)
		super.init()
	}

	/// Request URL as a String
	public var urlString: String {
		set(urlString) {
			Log.debug("SET \(urlString.rstrip)")
			if let url = URL(string:urlString.rstrip) {
				self.request = URLRequest(url:url)
				self.request.setValue(HTTPUserAgentKey.iOS.rawValue, forHTTPHeaderField: HTTPHeaderKey.userAgent.rawValue)
			} else {
				Log.error(NSError.error("Unable to parse url \(urlString)"))
			}
		}
		get {
			guard let url = self.request.url else {
				Log.warn("No URL set")
				return "http://127.0.0.1"
			}

			return url.absoluteString
		}
	}

	/// Request method as an HTTPMethodKey
	public var method: HTTPMethodKey {
		set(method) {
			Log.debug(method.rawValue)
			self.request.httpMethod = method.rawValue
		}
		get {
			guard let method = self.request.httpMethod else {
    		return HTTPMethodKey.get
			}

			switch method {
				case HTTPMethodKey.post.rawValue:
					return HTTPMethodKey.post
			default:
					return HTTPMethodKey.get
			}
		}
	}

	/// Request host target as a String
	public var host: String {
		set(host) {
			Log.debug(host)
			self.request.setValue(host, forHTTPHeaderField: HTTPHeaderKey.host.rawValue)
		}
		get {
			guard let hostString = self.request.value(forHTTPHeaderField: HTTPHeaderKey.host.rawValue) else {
				return ""
			}

			return hostString
		}
	}

	/// Request content type as an HTTPMIMEKey
	public var contentType: HTTPMIMEKey {
		set(contentType) {
			Log.debug(contentType.rawValue)
			self.request.setValue(contentType.rawValue, forHTTPHeaderField: HTTPHeaderKey.contentType.rawValue)
		}
		get {
			guard let mimeKey = self.request.value(forHTTPHeaderField: HTTPHeaderKey.contentType.rawValue) else {
				return HTTPMIMEKey.html
			}

			switch mimeKey {
			case HTTPMIMEKey.json.rawValue:
				return HTTPMIMEKey.json
			default:
				return HTTPMIMEKey.html
			}
		}
	}

	/// Request content length as an Int
	public var contentLength: Int {
		guard let data = self.postData else {
			return 0
		}
		return data.count
	}

	/// Request method as an HTTPMethodKey
	public var userAgent: HTTPUserAgentKey {
		set(userAgent) {
			Log.debug(userAgent.rawValue)
			self.request.setValue(userAgent.rawValue, forHTTPHeaderField: HTTPHeaderKey.userAgent.rawValue)
		}
		get {
			guard let userAgent = self.request.value(forHTTPHeaderField: HTTPHeaderKey.userAgent.rawValue) else {
				return HTTPUserAgentKey.iOS
			}

			switch userAgent {
			case HTTPUserAgentKey.iOS.rawValue:
				return HTTPUserAgentKey.iOS
			case HTTPUserAgentKey.android.rawValue:
				return HTTPUserAgentKey.android
			case HTTPUserAgentKey.macOS.rawValue:
				return HTTPUserAgentKey.android
			case HTTPUserAgentKey.windows.rawValue:
				return HTTPUserAgentKey.android
			default:
				return HTTPUserAgentKey.iOS
			}
		}
	}

	/// Setup a standard request
	private func standardSetup() {
		Log.stamp()

		self.contentType = .html

		self.request.cachePolicy = .reloadIgnoringLocalCacheData
		self.request.httpShouldHandleCookies = false
		self.request.timeoutInterval = 60

		self.request.setValue("close", forHTTPHeaderField: "Connection")
		self.request.setValue("1", forHTTPHeaderField: "Upgrade-Insecure-Requests")
		self.request.setValue("1", forHTTPHeaderField: "Dnt")
		self.request.setValue("text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", forHTTPHeaderField: HTTPHeaderKey.accept.rawValue)
		self.request.setValue("en-us", forHTTPHeaderField: HTTPHeaderKey.acceptLanguage.rawValue)
		self.request.setValue("gzip, deflate", forHTTPHeaderField: HTTPHeaderKey.acceptEncoding.rawValue)

		#if os(iOS)
		self.userAgent = .iOS
		#else
		self.userAgent = .macOS
		#endif
}

	/// Description
	///
	/// - Parameter urlString: url as a String
	/// - Returns: deserialized JSON payload as a dictionary
	public func getHTML(urlString: String) -> String {
		Log.stamp()
		Log.debug(urlString)
		self.urlString = urlString
		self.contentType = .html
		self.method = .get

		var result: String? = nil
		let cndlock = NSConditionLock(condition: 0)

		let downloadTask = session.downloadTask(with: request) { (url: URL?, response: URLResponse?, err: Error?) in
			cndlock.lock()
			if let url = url {
				// contents is in a file URL
				Log.debug(url.absoluteString)
				let payload = URLFetch.fetchStringContents(url.absoluteString)
				result = payload.0
				Log.debug(result!)
			} else {
				if err != nil {
					Log.error(err!)
					result = ""
				}
			}
			cndlock.unlock(withCondition: 1)
		}
		downloadTask.resume()
		cndlock.lock(whenCondition:1, before: NSDate.distantFuture)
		cndlock.unlock(withCondition: 0)

		guard result != nil else {
			return ""
		}

		return result!
	}

	/// Performs a POST of a JSON payload
	///
	/// - Parameters:
	///   - urlString: url as a String
	///   - json: payload of type String
	public func postJSON(urlString: String, json: [String: Any]) {
		Log.stamp()
		self.urlString = urlString
		self.contentType = .json
		self.method = .post

		let postData = JSON.encodeAsData(json)
		let uploadTask = session.uploadTask(with: request, from: postData!) { (data: Data?, response: URLResponse?, err: Error?) in
			if let error = err {
				Log.debug(error)
			} else {
				Log.debug(data)
			}
		}

		uploadTask.resume()
	}

	/// Description
	///
	/// - Parameter urlString: url as a String
	/// - Returns: deserialized JSON payload as a dictionary
	public func getJSON(urlString: String) -> [String: Any] {
		Log.stamp()
		self.urlString = urlString
		self.contentType = .json
		self.method = .get

		var result: [String: AnyObject]? = nil
		let cndlock = NSConditionLock(condition: 0)

		let downloadTask = session.downloadTask(with: request) { (url: URL?, response: URLResponse?, err: Error?) in
			cndlock.lock()
			if let url = url {
				Log.debug(url.absoluteString)
				// contents is in a file URL
				let payload = URLFetch.fetchDataContents(url.absoluteString)
				result = JSON.decodeData(payload.0)
				Log.debug(result)
			} else {
				if err != nil {
					Log.error(err!)
					result = ["": 0 as AnyObject]
				}
			}
			cndlock.unlock(withCondition: 1)
		}
		downloadTask.resume()
		cndlock.lock(whenCondition:1, before: NSDate.distantFuture)
		cndlock.unlock(withCondition: 0)

		return result!
	}
}
