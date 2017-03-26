import Foundation

public class Dispatch {

	/**
	required
	*/
	public init() {
	}

	/**
	*/
	public func executeBackground(block: DispatchWorkItem) {
		self.backgroundQueue.async(execute: block)
	}

	/**
	*/
	public func executeSync(queue: DispatchQueue, block: DispatchWorkItem) {
		queue.sync(execute: block)
	}

	/**
	*/
	public func executeAsync(queue: DispatchQueue, block: DispatchWorkItem) {
		queue.async(execute: block)
	}

	/**
	*/
	public var mainQueue: DispatchQueue {
		return DispatchQueue.main
	}

	/**
	*/
	public var backgroundQueue: DispatchQueue {
		return DispatchQueue.global(qos:.background)
	}

	/**
	*/
	public func customQueue(name: String) -> DispatchQueue {
		return DispatchQueue.init(label: name, attributes: .concurrent)
	}

	/**
	*/
	public static var isMainThread: Bool {
		return Thread.isMainThread
	}
}
