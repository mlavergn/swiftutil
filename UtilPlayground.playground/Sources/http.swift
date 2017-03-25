import Foundation

#if os(iOS)
import UIKit
#else
#endif

//var URLFetchCompletionHandler:((String)->Void)

public class JSONTask {
	var urlString: String?

	public func upload(url: String) {
		let sessionConfiguration = URLSessionConfiguration.default

		let session = URLSession(configuration:sessionConfiguration)

		let url = URL(string:url)
		var request = URLRequest(url:url!)

		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")

		request.httpMethod = "POST"
		// request.httpBody = postData;

		//	[multipartFormData addFile:data2 parameterName:@"file2" filename:@"myimage2.png" contentType:@"image/png"];

		let postData = JSON.encode(["name": "TEST IOS", "typemap": "IOS TYPE"])
		let uploadTask = session.uploadTask(with: request, from: postData!)

		uploadTask.resume()
	}

	public func fetch(url: String) -> Any {
//		public func fetchDataTask(_ url:String, completionHandler:((Data?, URLResponse?, Error?)->Void)) -> URLSessionDataTask {
	//		let contents = try! Data(contentsOf:URL(string:url)!)
			urlString = url
			return URLSessionDataTask()

	}

	private func _secret() {
//		URLSessionUploadTask(request:nil)
	}

//	public func imageToData(name:String) {
//		http://api.tryfixit.com/vl/
//	}

////	[multipartFormData addFile:data2 parameterName:@"file2" filename:@"myimage2.png" contentType:@"image/png"];
}
