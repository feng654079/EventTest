//
//  URLPathComponent.swift
//  EventTest
//
//  Created by apple on 2021/3/10.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

enum URLPathComponent {
    case plain(String)
    case placeholder(type: String? , key: String)
}

extension URLPathComponent {
    init (_ value: String) {
        if value.hasPrefix("<") && value.hasSuffix(">") {
            let start = value.index(after: value.startIndex)
            let end = value.index(before: value.endIndex)
            let placeholder = value[start..<end]
            let typeAndKey = placeholder.components(separatedBy: ":")
            if typeAndKey.count == 1 {
                self = .placeholder(type: nil, key: typeAndKey.first!)
            } else if typeAndKey.count == 2 {
                self = .placeholder(type: typeAndKey.first!, key: typeAndKey[1])
            } else {
                self = .plain(value)
            }
        } else {
            self = .plain(value)
        }
    }
}
