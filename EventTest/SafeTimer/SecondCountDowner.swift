//
//  CountDowner.swift
//  EventTest
//
//  Created by apple on 2021/1/29.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

   
/// 倒计时处理器
class SecondsCountDowner {
    let safeTimer: SafeDispatchSourceTimer
    private(set) var seconds:TimeInterval
    private lazy var tempSecond:TimeInterval = 0
    private lazy var lock = DispatchSemaphore(value: 1)
    
    init(seconds:TimeInterval,callBackQueue:DispatchQueue = .main) {
        self.safeTimer = SafeDispatchSourceTimer.init(queue: callBackQueue, repeating: 1.0)
        self.seconds = seconds
        self.tempSecond = self.seconds
    }
    
    deinit {
        debugPrint("SecondsCountDowner deinit")
    }
    
    typealias CountDownCallBack = (SecondsCountDowner,TimeInterval) -> Void
    lazy var callBack:CountDownCallBack? = nil
    
    func set(callBack:@escaping CountDownCallBack) {
        self.callBack = callBack
        self.safeTimer.setHandlder(target: self) { (s) in
            if s.tempSecond < 0.0 {
                s.stop()
                return
            }
            s.callBack?(s,s.tempSecond)
            s.tempSecond -= 1
        }
    }
}

//MARK: - Action
extension SecondsCountDowner {
    
    func pause() {
        self.safeTimer.suspend()
    }
    
    func stop() {
        self.safeTimer.suspend()
        lock.wait()
        tempSecond = seconds
        lock.signal()
    }
    
    func resume() {
        self.safeTimer.resume()
    }
}
