//
//  MainThreadStuckMonitor.swift
//  SwiftRunloop
//
//  Created by Ifeng科技 on 2020/9/1.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation


class MainThreadStuckMonitor {
    lazy private var _runloopMoitor = RunloopMonitor()
    lazy private var _nowActivity: CFRunLoopActivity? = nil
    lazy private var _monitoring = false
    lazy private var _semaphore =  DispatchSemaphore.init(value: 0)
    
    open private(set) var  mainThreadIsStuck:Bool = false
    init() {
        _runloopMoitor.addDelegate(delegate: self)
    }
    
    deinit {
        debugPrint("MainThreadStuckMonitor deinit")
    }
    
   open func startMonitoring() {
        if !_monitoring {
            _runloopMoitor.startMonitoring()
            self._monitoring = true
            DispatchQueue.global().async {
                [weak self] in
            
                ///不要强引用self, 会延长self的声明周期
                while self?._monitoring ?? false {
                    
                    ///主线程阻塞两秒以上卡在 beforeSources | afterWaiting 认为发生卡顿
                    let result = self?._semaphore.wait(timeout: .now() + .seconds(2))
                    if result == .timedOut &&
                        (self?._nowActivity ==  CFRunLoopActivity.beforeSources ||
                            self?._nowActivity == CFRunLoopActivity.afterWaiting
                        ){
                        self?.mainThreadIsStuck = true
                        debugPrint("发生了卡顿: activity:\(String(describing: self?._nowActivity))")
                    } else {
                        self?.mainThreadIsStuck = false
                    }
                }
                
                debugPrint("ping thread exit")
            }
        }
    }
    
   open func endMonitoring() {
        if _monitoring {
            _runloopMoitor.endMonitoring()
            _monitoring = false
        }
    }
}


extension MainThreadStuckMonitor:RunloopMonitorDelegate {
    
    func runloopCallback(monitor: RunloopMonitor, activity: CFRunLoopActivity) {
        _nowActivity = activity
        _semaphore.signal()
    }
    
    
}

extension CFRunLoopActivity:CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .entry: return "entry"
        case .beforeTimers: return "beforeTimers"
        case .beforeSources: return "beforeSources"
        case .beforeWaiting: return "beforeWaiting"
        case .afterWaiting: return "afterWaiting"
        case .exit: return "exit"
        default:
            return "unkown"
        }
    }
}


