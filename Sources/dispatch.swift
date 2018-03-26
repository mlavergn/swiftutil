/// Dispatch struct with GCD helpers
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

import Foundation

public struct Dispatch {

	/// Executes a block on a background queue
	///
	/// - Parameter block: execution block as DispatchWorkItem
	public static func executeBackground(block: DispatchWorkItem) {
		self.backgroundQueue.async(execute: block)
	}

	/// Executes a block synchronously on a given queue
	///
	/// - Parameter 
	///   - queue: execution queue as DispatchQueue
	///   - block: execution block as DispatchWorkItem
	public static func executeSync(queue: DispatchQueue, block: DispatchWorkItem) {
		queue.sync(execute: block)
	}

	/// Executes a block asynchronously on a given queue
	///
	/// - Parameter
	///   - queue: execution queue as DispatchQueue
	///   - block: execution block as DispatchWorkItem
	public static func executeAsync(queue: DispatchQueue, block: DispatchWorkItem) {
		queue.async(execute: block)
	}

	/// The main dispatch queue
	public static var mainQueue: DispatchQueue {
		return DispatchQueue.main
	}

	/// The shared background dispatch queue
	public static var backgroundQueue: DispatchQueue {
		return DispatchQueue.global(qos: .background)
	}

	/// Creates a new named queue
	///
	/// - Parameter name: name of the queue as a String
	/// - Returns: DispatchQueue associated with name
	public static func customQueue(name: String) -> DispatchQueue {
		return DispatchQueue.init(label: name, attributes: .concurrent)
	}

	/// True if caller is on the main thread, otherwise false
	public static var isMainThread: Bool {
		return Thread.isMainThread
	}
}
