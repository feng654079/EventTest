//
//  ThreadTest.swift
//  EventTest
//
//  Created by apple on 2020/9/29.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
class ThreadSafeTest {
    private let queue = DispatchQueue.init(label: "ThreadSafeTest.serialQueue")
    private var intArr = [1,2,3,4,5]
    private let arrLock = NSLock()
    
    ///下面这段代码是线程安全的吗? 原因是什么?
    func test() {
        _serialQueueNotSafeTest()
        _serialQueueNotSafeTest()
        

    }
    
    ///同一个ThreadSafeTest对象 连续调用两次这个方法即可导致崩溃
    private func _serialQueueNotSafeTest() {
    
        queue.async { [self] in
            debugPrint(Thread.current)
            
          
            intArr.removeAll()
            for idx in 0..<1000 {
                intArr.append(idx)
            }
          
            
            DispatchQueue.main.async {
                for idx in 0..<intArr.count {
                    debugPrint(intArr[idx])
                }
            }
        }
    }
    
    ///线程安全的版本
    ///方法一:加锁
    private func _serialQueueSafeTest1() {
        queue.async { [self] in
            debugPrint(Thread.current)
            
            arrLock.lock()
            intArr.removeAll()
            for idx in 0..<1000 {
                intArr.append(idx)
            }
            arrLock.unlock()
          
            
            DispatchQueue.main.async {
                arrLock.lock()
                for idx in 0..<intArr.count {
                    debugPrint(intArr[idx])
                }
                arrLock.unlock()
            }
        }
    }
    
    ///方法二: 主线程同步
    private func _serialQueueSafeTest2() {
        queue.async { [self] in
            debugPrint(Thread.current)
            
            intArr.removeAll()
            for idx in 0..<1000 {
                intArr.append(idx)
            }
          
            ///主线程同步执行
            DispatchQueue.main.sync {
                arrLock.lock()
                for idx in 0..<intArr.count {
                    debugPrint(intArr[idx])
                }
                arrLock.unlock()
            }
        }
    }
}
