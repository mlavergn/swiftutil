/// Lockable class with synchronization related helpers
///
/// Spinlocks are illegal on iOS / macOS since iOS 10
/// QoS can starve low priorty threads
/// https://lists.swift.org/pipermail/swift-dev/Week-of-Mon-20151214/000372.html
/// #import <libkern/OSAtomic.h>
/// static OSSpinLock _someLock = OS_SPINLOCK_INIT
/// OSSpinLockLock(& _someLock)
/// OSSpinLockUnlock(& _someLock)
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT
import Foundation
import Darwin

public class Lockable {

	/// Shared condition for non-queue waits
	let cnd = NSCondition()

	/// Shared condition lock for queueing
	let cndlock = NSConditionLock(condition: 0)

	/// Required
	public init() {
	}

	/// Obtain the shared lock
	public func hold() {
		cnd.lock()
	}

	/// Park the current thread unti signaled
	public func wait() {
		cnd.wait()
	}

	/// Wake the next waiting thread
	public func wakeSingle() {
		cnd.signal()
	}

	/// Wake all waiting threads
	public func wakeAll() {
		cnd.broadcast()
	}

	/// queues the next work block
	///
	/// - Parameter block: block of work to perform as a closure
	public func queue(block: @autoclosure() -> Void) {
		cndlock.lock(whenCondition: 1)
		block()
		cndlock.unlock(withCondition: 0)
	}

	/// dequeues the next work block
	///
	/// - Parameter block: block of work to perform as a closure
	public func dequeue(block: @autoclosure() -> Void) {
		cndlock.lock(whenCondition: 0)
		block()
		cndlock.unlock(withCondition: 1)
	}
}
