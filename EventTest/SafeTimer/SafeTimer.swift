//
//  SafeTimer.swift
//  TimerTest
//
//  Created by Ifeng科技 on 2020/8/5.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation

struct TimerProxy  {
    
    private weak var _target:AnyObject?
    var target:AnyObject? { return _target }
    
    init(target:AnyObject) {
        self._target = target
    }
    
//    deinit {
//        debugPrint("\(self) deinit")
//    }
}

/**
 更加安全的timer.
 系统的DispatchSourceTimer有以下几个坑点:
    1.多次连续调用resume 和 suspend  一次以上就会崩溃
    2.在timer的状态为suspend状态时, 如果其作为属性释放,引起EXC_BAD_INSTRUCTION崩溃
 
 */
class SafeDispatchSourceTimer {
    
    private let timer:DispatchSourceTimer

    init(queue: DispatchQueue,repeating:Double,deadline:DispatchTime = .now()) {
        self.timer = DispatchSource.makeTimerSource(flags: .init(), queue: queue)
        self.timer.schedule(deadline: deadline, repeating: repeating)
    }
    
    deinit {
        /**
         当DispatchSourceTimer是suspend状态作为属性释放时,系统
         会调用一次cancel()方法来销毁timer,这时会引起EXC_BAD_INSTRUCTION崩溃问题
         但是DispatchSourceTimer没有给出状态查询的接口,所以这里手动修改一下
         注意:DispatchSourceTimer刚刚创建出来也是suspend状态
         */
        if _state == .suspend ||
            _state == .initial {
            ///因为已经要释放了,所以清空外界的回调没有问题
            _handler = nil
            timer.resume()
            debugPrint("\(self) deinit resume timer")
        }
    
        debugPrint("\(self) deinit")
    }
    
    private var _handler:AnyObject?
    
    ///在block中不要饮用safetime
    func setHandlder<T>(target:T ,handler:@escaping (T)->Void) {
        self._handler = handler as AnyObject
        let proxy = TimerProxy.init(target: target as AnyObject)
        self.timer.setEventHandler {
            [weak self] in
            
            if
                let c = self ,
                let h = c._handler as? ((T)->Void),
                let t = proxy.target as? T
            {
                 h(t)
            }
        }
    }
    
    private enum State {
        case initial
        case resume
        case suspend
    }
    private lazy var _state:State = .initial
    
    private func _chaneToState(state:State) -> Bool {
        
        ///to initial return false
        ///initial is the start point
        
        /// to resume
        if state == .resume {
            if _state == .initial ||
               _state == .suspend {
                /// only initial and .suspend can become to .resume
                _state = .resume
                return true
            }
        }
        
        /// to suspend
        if state == .suspend {
            if _state == .resume {
                /// only .suspend can become to .suspend
                _state = .suspend
                return true
            }
        }
        return false
            
    }
    
    func resume() {
        if _chaneToState(state: .resume) {
            _resume()
        }
    }
    
    func suspend() {
        if _chaneToState(state: .suspend) {
            _suspend()
        }
    }
    
    private func _resume() {
        timer.resume()
    }
    
    private func _suspend() {
        debugPrint("safe timer suspend")
        timer.suspend()
    }
    
    
}
