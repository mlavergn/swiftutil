/// HTTP class with HTML and JSON functionality
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

import Foundation

public class HTTPBackground: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    public static func demoBackgroundFetch() {
        guard let url = URL.init(string: "https://jsonplaceholder.typicode.com/posts") else {
            print("error")
            return
        }

        let uuid = "com.example." + NSUUID().uuidString
        let params: [AnyHashable: Any] = [
            "title": "foo",
            "body": "bar",
            "userId": 1
        ]
        guard let body = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            print("error")
            return
        }
        HTTPBackground().backgroundSession(url, uniqueId: uuid, body: body, delay: Date().addingTimeInterval(30))
    }

    @discardableResult
    public func backgroundSession(_ url: URL, uniqueId: String, body: Data, delay: Date = Date()) -> URLSessionDataTask {
        let config = URLSessionConfiguration.background(withIdentifier: uniqueId)
        config.allowsCellularAccess = true
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 5 * 60 // how many seconds is a session valid (5 mins)
        config.httpMaximumConnectionsPerHost = 4
        config.networkServiceType = .background
        config.isDiscretionary = false
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        
        let backgroundTask = session.dataTask(with: request)
        backgroundTask.earliestBeginDate = delay
        backgroundTask.countOfBytesClientExpectsToSend = Int64(body.count)
        backgroundTask.countOfBytesClientExpectsToReceive = 1024

        backgroundTask.resume()
        return backgroundTask
	}
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(#function)
    }
}
