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

/// Conditional lock states
///
/// - READY: Ready to block a task
/// - FINISHED: Ready to unblock a task
public enum FutureState: Int {
	case ready = 0
	case finished
}

public class Future: NSObject {

	/// Shared condition for non-queue waits
	let cnd = NSCondition()

	/// Obtain the shared lock
	public func hold() {
		cnd.lock()
	}

	/// Park the current thread until signaled
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

    /// Shared condition lock for queueing
    let cndlock = NSConditionLock(condition: FutureState.ready.rawValue)

	/// queues the next work block
	///
	/// - Parameter block: block of work to perform as a closure
	public func queue(block: @autoclosure() -> Void) {
		cndlock.lock(whenCondition: FutureState.finished.rawValue)
		block()
		cndlock.unlock(withCondition: FutureState.ready.rawValue)
	}

	/// dequeues the next work block
	///
	/// - Parameter block: block of work to perform as a closure
	public func dequeue(block: @autoclosure() -> Void) {
		cndlock.lock(whenCondition: FutureState.ready.rawValue)
		block()
		cndlock.unlock(withCondition: FutureState.finished.rawValue)
	}
}
