//
//  PropertyWrapper.swift
//  EventTest
//
//  Created by apple on 2021/2/24.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

@propertyWrapper
@dynamicMemberLookup
final class MyProtected<T> {
    
    private var value: T
    init (_ value: T) {
        self.value = value
    }
    
    private let lock = NSLock()
    
    var wrappedValue: T {
        get { lock.around { value } }
        set { lock.around { value = newValue } }
    }
    
    subscript<Property>(dynamicMember keyPath:WritableKeyPath<T,Property>) -> Property {
        get { lock.around { value[keyPath: keyPath] } }
        set { lock.around { value[keyPath: keyPath] = newValue }}
    }
}

//MARK: -
extension NSLock {
    func around<T>(_ closure: () -> T) -> T {
        lock()
        defer { unlock()}
        return closure()
    }
}
