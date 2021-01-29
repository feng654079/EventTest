//
//  EONET.swift
//  EventTest
//
//  Created by apple on 2020/10/10.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum EOError:Error {
    case invalidURL(url:String)
    case invalidParameter(key:String, value:Any)
    case invalidJSON(url:String)
}

struct EOCategory {
    var id:String = ""
    let name: String
    let description: String
    
    var events:[EOEvent] = []
    
    let endPoint = ""
}

struct EOEvent {
    var categories: [String] = []
    
    let closedDate: TimeInterval = 0
    let startDate: TimeInterval = 0
}

final class EONET {

    static var categories:Observable<[EOCategory]> = {
        return request(endPoint: "")
            .map { _ in
                return [EOCategory(name: "黑洞", description: "宇宙有道理")]
            }
            .share(replay: 1)
    }()
    
    
    static func events(forLast days: Int = 360,category:EOCategory ) -> Observable<[EOEvent]> {
        let openEvents = events(forLast: days, closed: false ,endPoint: category.endPoint)
        let closedEvents = events(forLast: days, closed: true,endPoint: category.endPoint)
        return Observable.of(openEvents,closedEvents)
            .merge()
            .reduce([]) {
                running,new in
                running + new
            }
    }
    
    static func filteredEvents(events:[EOEvent] ,for category:EOCategory) -> [EOEvent] {
        var result = [EOEvent]()
        for e in events {
            if e.categories.contains(category.id) {
                result.append(e)
            }
        }
        return result
    }
    
    //MARK: - basic
    
    static let API = "https://www.xxx.com"
    
    static func request(endPoint: String, query: [String:Any] = [:]) -> Observable<[String:Any]>  {
        
        do {
            guard let url = URL(string: API)?.appendingPathComponent(endPoint),
                  var components = URLComponents(url:url,resolvingAgainstBaseURL: true) else  {
                throw EOError.invalidURL(url: endPoint)
            }
            
            components.queryItems = try query.compactMap { (key,value)  in
                guard let v = value as? CustomStringConvertible else {
                    throw EOError.invalidParameter(key: key, value: value)
                }
                return URLQueryItem(name: key, value: v.description)
            }
            
            guard let finalURL = components.url else {
              throw EOError.invalidURL(url: endPoint)
            }
            
            let request = URLRequest(url: finalURL)
            
            return URLSession.shared.rx.response(request: request)
                .map { _ , data -> [String:Any] in
                    guard let jsonObj = try? JSONSerialization.jsonObject(with: data, options: []),
                          let result = jsonObj as? [String:Any] else {
                        throw EOError.invalidJSON(url: finalURL.absoluteString)
                    }
                    return result
                }
        } catch {
            return Observable.empty()
        }
        
    }
    
    fileprivate static func events(forLast days:Int , closed:Bool,endPoint:String) -> Observable<[EOEvent]> {
        return request(endPoint: endPoint, query: [
            "days":NSNumber(value: days),
            "closed": closed ? "closed" : "open"
        ])
        .map {
            json in
            guard let _ = json["events"] as? [[String:Any]] else {
                throw EOError.invalidJSON(url: endPoint)
            }
            return [EOEvent()]
        }
    }
}
