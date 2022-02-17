//
//  ModelCodable.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/7/7.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation

protocol ModelDecodeable {
    static func decode(from json:Data?) -> Self?
}

protocol ModelEncodeable {
    func toJson() -> Data?
}

typealias ModelCodable = ModelDecodeable & ModelEncodeable
