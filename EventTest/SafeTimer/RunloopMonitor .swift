//
//  RunloopMonitor .swift
//  SwiftRunloop
//
//  Created by Ifeng科技 on 2020/9/1.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation


//MARK:runloop callback
fileprivate func _runloopCallBack(observer:CFRunLoopObserver?,avtivity:CFRunLoopActivity,info:UnsafeMutableRawPointer?) -> Void {
    
    if let info = info {
        let monitor = Unmanaged<RunloopMonitor>.fromOpaque(info).takeUnretainedValue()
        monitor._callDelegateMethods(activity: avtivity)
    }
   
}

public protocol RunloopMonitorDelegate {
    func runloopCallback(monitor:RunloopMonitor,activity:CFRunLoopActivity)
}

open class RunloopMonitor {
    
    static let shared = RunloopMonitor()
    
    ///在RunloopMonitor释放时自动移除对runloop的监听
    ///这个属性最好为开启状态,如果要关闭这个属性的的话
    ///那么必须在RunloopMonitor 释放之前结束对runloop的监听,否则崩溃
    open var autoEndMonitoring:Bool = true
    deinit {
        if autoEndMonitoring {
            endMonitoring()
        }
        debugPrint("RunloopMonitor deinit")
    }
    
   
    lazy private var _runLoop:CFRunLoop? = nil
    lazy private var _mode:CFRunLoopMode? = nil
    lazy private var _runLoopObserver:CFRunLoopObserver? = nil
    lazy private var _info:UnsafeMutableRawPointer? = nil
    
    lazy private var _delegateSet = NSHashTable<AnyObject>.init(options: .weakMemory)
    
    open var isMonitoring:Bool {
        let notMoitoring = _runLoop == nil && _mode == nil && _runLoopObserver == nil && _info == nil
        return !notMoitoring
    }
    
    /// 添加弱引用委托
   open func addDelegate(delegate:RunloopMonitorDelegate) {
        _delegateSet.add(delegate as AnyObject)
    }
    
    
   open func startMonitoring(runloop:CFRunLoop = CFRunLoopGetMain() ,mode:CFRunLoopMode = CFRunLoopMode.defaultMode) {
        
        if isMonitoring == false {
            
            _runLoop = runloop
            _mode = mode
            
            _info = Unmanaged<RunloopMonitor>.passUnretained(self).toOpaque()
            
            var ctx = CFRunLoopObserverContext.init(version: 0, info: _info, retain: nil, release: nil, copyDescription: nil)
            
            _runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, CFRunLoopActivity.allActivities.rawValue, true, 0, _runloopCallBack, &ctx)
            
            CFRunLoopAddObserver(_runLoop, _runLoopObserver, _mode)
        }
    }
    
    open func endMonitoring() {
        if isMonitoring {
            CFRunLoopRemoveObserver(_runLoop, _runLoopObserver, _mode)
            _clear()
        }
    }
    
    //MARK: - private
    private func _clear() {
        _runLoop = nil
        _runLoopObserver = nil
        _mode = nil
        _info = nil
    }
    
    fileprivate func _callDelegateMethods(activity:CFRunLoopActivity) {
        for obj in _delegateSet.allObjects {
            if  let d = obj as? RunloopMonitorDelegate {
                d.runloopCallback(monitor: self, activity: activity)
            }
        }
    }
}
