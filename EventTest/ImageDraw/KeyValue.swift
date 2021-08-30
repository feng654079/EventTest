//
//  KeyValue.swift
//  EventTest
//
//  Created by apple on 2021/2/23.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

///表示键值对,主要用来测试字典字面量初始化
struct KeyValue {
    
    let key:String
    let value:String
    
    init(key:String,value:String) {
        self.key = key
        self.value = value
    }
}

extension KeyValue {
    ///是否是有效的键值对
    var isValid: Bool {
        return key != ""
    }
}

//MARk: - 使用字典形式初始化
extension KeyValue:ExpressibleByDictionaryLiteral {
    init(dictionaryLiteral elements: (String, String)...) {
        guard
            elements.count > 0
        else {
            self.init(key: "", value: "")
            return
        }
        self.init(key: elements.first!.0, value: elements.first!.1)
    }
}

//MARk: - 测试用例
extension KeyValue {
    
    static func testKeyValue()  {
        let kv1:KeyValue = ["name":"xxx"]
        let kv2:KeyValue = [:]
        let kv3:KeyValue = ["k1":"v1","k2":"v2"]
        
        if kv1.key != "name" || kv1.value != "xxx" || kv1.isValid == false {
            fatalError()
        }
        
        if kv2.key != "" || kv2.value != "" || kv2.isValid == true {
            fatalError()
        }
        
        if kv3.key != "k1" || kv3.value != "v1" || kv3.isValid == false {
            fatalError()
        }
        
        debugPrint("KeyValue:ExpressibleByDictionaryLiteral Test Success!")
    }
}

