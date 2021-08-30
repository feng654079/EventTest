//
//  URLConvertible.swift
//  EventTest
//
//  Created by apple on 2021/3/10.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

public protocol URLConvertible {
    var urlValue: URL? { get }
    var urlStringValue: String { get }
    var queryParamenters: [String:String] { get }
    var queryItems: [URLQueryItem]? { get }
}

//MARK: -
extension URLConvertible {
    public var queryParamenters: [String:String] {
        var parameters = [String:String]()
        self.urlValue?.query?.components(separatedBy: "&")
            .forEach({ (comp) in
                guard let separatorIndex = comp.firstIndex(of: "=") else { return }
                let key = comp[comp.startIndex..<separatorIndex]
                let value = comp[comp.index(after:separatorIndex)..<comp.endIndex]
                parameters[String(key)] = String(value).removingPercentEncoding ?? String(value)
            })
        return parameters
    }
    
    public var queryItems: [URLQueryItem]? {
        return URLComponents.init(string: self.urlStringValue)?.queryItems
    }
}

extension URLConvertible {
    public func map<T>(_ transform:(URLConvertible) -> T) -> T {
        return transform(self)
    }
}


//MARK: - String

extension String: URLConvertible {
    public var urlValue: URL? {
        if let url = URL(string: self) {
            return url
        }
        var set = CharacterSet()
        set.formUnion(.urlHostAllowed)
        set.formUnion(.urlQueryAllowed)
        set.formUnion(.urlPathAllowed)
        set.formUnion(.urlFragmentAllowed)
        return self.addingPercentEncoding(withAllowedCharacters: set).flatMap { URL(string: $0 )}
    }
    
    public var urlStringValue: String {
        return self
    }
}


//MARK: - URL
extension URL: URLConvertible {
    public var urlValue: URL? {
        return self
    }
    
    public var urlStringValue: String {
        return self.absoluteString
    }

}
