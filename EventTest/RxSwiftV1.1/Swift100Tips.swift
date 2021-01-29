//
//  Swift100Tips.swift
//  EventTest
//
//  Created by apple on 2020/11/6.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

protocol TargetAction {
    func performAction()
}

struct TargetActionWrapper<T:AnyObject>: TargetAction {
    
    weak var target: T?
    
    let action: (T) -> () -> ()
    
    func performAction() {
        if let t = target {
            action(t)()
        }
    }
}

enum ControllEvent {
    case touchUpInside
    case valueChanged
}

class Control {
    var actions = [ControllEvent:TargetAction]()
    
    func setTarget<T:AnyObject>(target:T ,
                                action: @escaping (T) -> () -> () ,
                                controlEvent:ControllEvent) {
        actions[controlEvent] = TargetActionWrapper(target: target, action: action)
    }
    
    func removeTarget(for controlEvent:ControllEvent) {
        actions[controlEvent] = nil
    }
    
    func performAction(for controlEvent:ControllEvent) {
        actions[controlEvent]?.performAction()
    }
}


///获取数组中几个特定位置的元素
extension Array {
    subscript(input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
                if self.indices.contains(i) {
                    result.append(self[i])
                } else {
                    fatalError("index:\(i) out of range")
                }
            }
            return result
        }
        
        set {
            for i in input {
                if self.indices.contains(i) {
                    self[i] = newValue[i]
                } else {
                    fatalError("index:\(i) out of range")
                    
                }
            }
        }
    }
}


///模块内命名空间,只能对类生效
struct FYL {
    class ClassA {
        
    }
}
extension FYL {
    class ClassB {
        
    }
}


protocol AFood {
    
}

struct Meat:AFood {
    
}
struct Grass:AFood {
    
}

protocol  Animal {
    
    associatedtype F:AFood
    
    func eat(_ food:F)
}

struct Tiger: Animal {
    func eat(_ food: Meat) {
        debugPrint("tiger eat meat")
    }
}

struct Sheep: Animal {
    func eat(_ food: Grass) {
        debugPrint("sheep eat grasses")
    }
}

extension Animal {
    ///某个动物时候危险, nil为未知
    func isDangerous() -> Bool? {
        if self is Tiger {
            return true
        } else if self is Sheep {
            return false
        }
        
        return nil
    }
}

fileprivate func test() {
    ///找到纯英文单词中的大写字母
    do {
        let str = "helLo"
        let interval = "a"..."z"
        for c in str {
            if !interval.contains(String(c)) {
                debugPrint("\(c) 不是小写字母")
            }
        }
    }
    
    
    ///not lazy
    
    do {
        let data = 1...3
        let result = data.map {
            (d:Int) -> Int in
            debugPrint("正在处理\(d)")
            return d
        }
        
        for c in result {
            debugPrint("结果:\(c)")
        }
    }
    
    /// lazy
    do {
        let data = 1...3
        let result = data.lazy.map {
            (d:Int) -> Int in
            debugPrint("正在处理\(d)")
            return d
        }
        
        for c in result {
            debugPrint("结果:\(c)")
        }
    }
    
    do {
        let c = DispatchWorkItem.init {
            debugPrint("哈哈哈")
        }
        
        
    }
    

    
}



indirect enum LinkList<Element> {
    case empty
    case node(element:Element,next:LinkList<Element>)
}

extension LinkList {
    func removing(element:Element) -> LinkList<Element>
    where Element: Comparable{
        guard case let .node(value, next) = self else {
            return .empty
        }
        
        return value == element ? next : .node(element: value, next: next.removing(element: element))
    }
    
    #if os(iOS)
    #elseif os(Windows)
    #elseif os(Linux)
    #elseif os(watchOS)
    #elseif os(Android)
    #elseif os(macOS)
    #elseif os(tvOS)
    #elseif os(FreeBSD)
    #endif
}

typealias Task = (_ cancel: Bool) -> Void

fileprivate func delay(_ time:TimeInterval,task:@escaping () -> Void) -> Task? {
    
    func dispatch_later(block:@escaping () -> Void) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    
    var closure: (()->Void)? = task
    var result: Task?
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if cancel == false {
                DispatchQueue.main.async(execute: internalClosure)
            }
          
        }
        
        
        closure = nil
        result = nil
    }
    result = delayedClosure
    dispatch_later {
        if let r = result {
            r(false)
        }
    }
    return result
}

fileprivate func cancel(_ task:Task?) {
    task?(true)
}


fileprivate class Address {
    var street: String
    init(street: String) {
        self.street = street
    }
}

fileprivate class Person {
    var name:String
    var addresses:[Address]
    
    init(name:String,addresses:[Address]) {
        self.name = name
        self.addresses = addresses
    }
}


final class ValueMointor<T> {
    
}


func random(in range:Range<Int>) -> Int {
   
    
    let count = UInt32(range.endIndex - range.startIndex)
    return Int(arc4random_uniform(count)) + range.startIndex
}





 
