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
	public func lock(before limit: Date) -> Bool {
//					_cond.lock()
//         while _thread != nil {
//							if !_cond.wait(until: limit) {
//									_cond.unlock()
//									return false
//							}
//					}
		return true
	}
}
