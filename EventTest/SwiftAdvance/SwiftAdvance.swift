//
//  SwiftAdvance.swift
//  EventTest
//
//  Created by apple on 2020/10/28.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

//MARK: Codeable


struct Coordinate: Codable {
    var latitude: Double
    var longitude: Double
}

struct Placemark: Codable {
    var name: String
    var coordinate: Coordinate
}

enum MyError: Error {
    case w
}



fileprivate func test() {
    let places = [
        Placemark(name: "Berlin", coordinate: Coordinate(latitude: 50, longitude: 50)),
        Placemark(name: "Cape Town", coordinate: Coordinate(latitude: 50, longitude: 50)),
    ]
    
    ///encoding
    do {
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(places)
        let jsonString = String(data: jsonData, encoding: .utf8)
        debugPrint(jsonString ?? "")
        
        ///decoding
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode([Placemark].self, from: jsonData)
             _ = type(of: decoded)
            //decoded === places // true
        }
    }
    catch {
        debugPrint(error.localizedDescription)
    }
    
    let w: Result<Void,MyError> = .failure(.w)
    debugPrint(w)
    
    _ = [1,2].all { $0 > 2 }
    
    let ints = [1,2]
    let strings = ["1","2","3"]
    _ = ints.isSubset(of: strings) {
        String($0) == $1
    }
}

@_specialize(exported: true, where T == Int)
@_specialize(exported: true, where T == String)
public func a<T:CustomStringConvertible>(p:T) {
    debugPrint(p.description)
}

extension Sequence {
    func  all(match predicate:(Element) throws -> Bool) rethrows -> Bool {
        for e in self {
            guard try predicate(e) else { return false }
        }
        return true
    }
}

extension Sequence {
    func isSubset<S:Sequence>(of other:S,by areEquivalent:(Element,S.Element) -> Bool)
    -> Bool
    {
        for e in self {
            guard other.contains(where: {
                areEquivalent(e,$0)
            }) else {
                return false
            }
        }
        return true
    }
}

