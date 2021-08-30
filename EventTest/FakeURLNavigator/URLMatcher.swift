//
//  URLMatcher.swift
//  EventTest
//
//  Created by apple on 2021/3/10.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation

/// Represents an URL match result.
public struct URLMatchResult {
  /// The url pattern that was matched.
  public let pattern: String

  /// The values extracted from the URL placeholder.
  public let values: [String: Any]
}

//MARK: -
open class URLMatcher {
    public typealias URLPattern = String
    public typealias URLValueConverter = (_ pathComponents: [String], _ index: Int) -> Any?
    
    static func defaultURLValueConverter(for type:String) -> URLValueConverter? {
        switch type {
        case "string":
            return { $0[$1] }
        case "int":
            return { Int($0[$1]) }
        case "float":
            return { Float($0[$1]) }
        case "uuid":
            return { UUID(uuidString: $0[$1]) }
        case "path":
            return { $0[$1..<$0.count].joined(separator: "/") }
        default:
            return nil
        }
    }
    
    open func match(_ url: URLConvertible, from candidates: [URLPattern]) -> URLMatchResult? {
        let url = self.normalizeURL(url)
        let scheme = url.urlValue?.scheme
        let stringPathComponents = self.stringPathComponents(from: url)
        var results = [URLMatchResult]()
        for candidate in candidates {
            guard scheme == candidate.urlValue?.scheme else {
                continue
            }
        }
        
        return nil
    }
}


//MARK: -
extension URLMatcher {
    
    func normalizeURL(_ dirtyURL: URLConvertible) -> URLConvertible {
      guard dirtyURL.urlValue != nil else { return dirtyURL }
      var urlString = dirtyURL.urlStringValue
      urlString = urlString.components(separatedBy: "?")[0].components(separatedBy: "#")[0]
      urlString = self.replaceRegex(":/{3,}", "://", urlString)
      urlString = self.replaceRegex("(?<!:)/{2,}", "/", urlString)
      urlString = self.replaceRegex("(?<!:|:/)/+$", "", urlString)
      return urlString
    }

    
    func replaceRegex(_ pattern: String,_ repl: String, _ string: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return string }
        let range = NSMakeRange(0, string.count)
        return regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: repl)
    }
    
    func stringPathComponents(from url: URLConvertible) -> [String] {
      return url.urlStringValue.components(separatedBy: "/").lazy.enumerated()
        .filter { index, component in !component.isEmpty }
        .filter { index, component in !self.isScheme(index, component) }
        .map { index, component in component }
    }
    
    func isScheme(_ index: Int, _ component: String) -> Bool {
        return index == 0 && component.hasSuffix(":")
    }
    
    func match(_ stringPathComponents: [String], with candidate: URLPattern) -> URLMatchResult? {
        let normalizedCandidate = self.normalizeURL(candidate)
        let candidatePathComponents = self.stringPathComponents(from: normalizedCandidate).map (URLPathComponent.init)
        guard self.ensurePathComponentsCount(stringPathComponents, candidatePathComponents) else {
            return nil
        }
        var urlValues: [String:Any] = [:]
        let pairCount = min(stringPathComponents.count,candidatePathComponents.count)
        
        return nil
        
    }
   
    ///确保path是合法的
    func ensurePathComponentsCount(
        _ stringPathComponents: [String],
        _ candidatePathComponents: [URLPathComponent]
    ) -> Bool {
        let hasSameNumberOfComponents = (stringPathComponents.count == candidatePathComponents.count)
        let containsPathPlaceholderComponent = candidatePathComponents.contains {
            if case let .placeholder(type,_) = $0, type == "path" {
                return true
            } else {
                return false
            }
        }
        return hasSameNumberOfComponents || (containsPathPlaceholderComponent && stringPathComponents.count > candidatePathComponents.count)
        
    }
    
}
