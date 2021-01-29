//
//  PeriodicExecution.swift
//  SwiftRunloop
//
//  Created by Ifeng科技 on 2020/9/1.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation

protocol PeriodicExecutionTask {
    ///调用不是在主线程
    func perform()
}

class PeriodicExecution {
    private static let _timerQueue = DispatchQueue.init(label: "PeriodicExecution.timerQueue")
    
    private let _safeTimer = SafeDispatchSourceTimer(queue: PeriodicExecution._timerQueue, repeating: 1.0, deadline: .now())
    
    lazy private var _mainThreadStuckMonitor = MainThreadStuckMonitor()
    
    lazy private var _tasks = NSHashTable<AnyObject>.init(options: .weakMemory)
    
    init() {
        
        _safeTimer.setHandlder(target: self) { (s) in
            if s._mainThreadStuckMonitor.mainThreadIsStuck { return }
            for obj in s._tasks.allObjects {
                if let task = obj as? PeriodicExecutionTask {
                    task.perform()
                }
            }
        }
    }
    
    deinit {
        debugPrint("PeriodicExecution deinit.")
    }
    
    func addTask(task:PeriodicExecutionTask) {
        _tasks.add(task as AnyObject)
    }
    
    func startPerform() {
        _mainThreadStuckMonitor.startMonitoring()
        _safeTimer.resume()
    }
    
    func endPerform() {
        _mainThreadStuckMonitor.endMonitoring()
        _safeTimer.suspend()
    }
}
