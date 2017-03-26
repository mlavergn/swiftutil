import Foundation
import Darwin

/**
Spinlocks are illegal on iOS / macOS since iOS 10
QoS can starve low priorty threads
https://lists.swift.org/pipermail/swift-dev/Week-of-Mon-20151214/000372.html
#import <libkern/OSAtomic.h>
static OSSpinLock _someLock = OS_SPINLOCK_INIT
OSSpinLockLock(& _someLock)
OSSpinLockUnlock(& _someLock)
*/

public class Lockable {

	let cndlock = NSConditionLock(condition: 0)
	let cnd = NSCondition()

	/**
	*/
	public init() {

	}

	/**
	*/
	public func hold() {
		cnd.lock()
	}

	/**
	*/
	public func wait() {
		cnd.wait()
	}

	/**
	*/
	public func wakeSingle() {
		cnd.signal()
	}

	/**
	*/
	public func wakeAll() {
		cnd.broadcast()
	}

	/**
	*/
	public func queue(block: @autoclosure() -> Void) {
		cndlock.lock(whenCondition: 1)
		block()
		cndlock.unlock(withCondition: 0)
	}

	/**
	*/
	public func dequeue(block: @autoclosure() -> Void) {
		cndlock.lock(whenCondition: 0)
		block()
		cndlock.unlock(withCondition: 1)
	}
}
