//
//  PerfectLock.swift
//  EventTest
//
//  Created by apple on 2021/1/29.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

//MARK: - 封装Lock

///在 iOS 10.0 以后 使用os_unfai_lock, 否则使用信号量
///这样做的目的是抹平iOS版本差异,性能会比使用对应的锁稍差一点,差异就是函数调用的开销
///但是比NSLock强
///(写在全局函数的返回的NSLocking才能用,不知道是不是编译器的问题╮(╯▽╰)╭)

struct PerfectLock {
    static func GetLock() -> NSLocking {
        if #available(iOS 10.0, *) {
            return UnFairLock()
        } else {
            return SemphoreLock()
        }
    }
}

class SemphoreLock: NSLocking {
    private let _semphoreLock = DispatchSemaphore(value: 1)
    
    @inlinable
    func lock() {
        _semphoreLock.wait()
    }
    
    @inlinable
    func unlock() {
        _semphoreLock.signal()
    }
}

@available(iOS 10.0, *)
class UnFairLock: NSLocking {
    
    private let _lock: os_unfair_lock_t
    init() {
        _lock = .allocate(capacity: 1)
    }
    
    @inlinable
    func lock() {
        os_unfair_lock_lock(_lock)
    }
    
    @inlinable
    func unlock() {
        os_unfair_lock_unlock(_lock)
    }
}

