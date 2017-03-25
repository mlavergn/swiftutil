import Foundation

public class Dispatch {
	let queue = DispatchQueue.global(qos:.background)

	// required
	public init() {
	}

	public func executeBackground(block: DispatchWorkItem) {
		queue.async(execute: block)
	}
}

// dispatch queue
//
//dispatch_queue_t get_my_background_queue() {
//	static dispatch_once_t once;
//	static dispatch_queue_t my_queue;
//	dispatch_once(&once, ^{
//		my_queue = dispatch_queue_create("com.example.background", NULL);
//	});
//	return my_queue;
//}
//
//
//// main thread
//dispatch_async(dispatch_get_main_queue(), ^{
//    NSLog(@"%s", [NSThread isMainThread] ? "main" : "other");
//});
//
//// backgound thread
//dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    NSLog(@"%s", [NSThread isMainThread] ? "main" : "other");
//});
