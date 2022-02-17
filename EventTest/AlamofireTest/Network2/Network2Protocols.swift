//
//  NetworkProtocols.swift
//  SwiftProject
//
//  Created by Ifeng科技 on 2020/5/20.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation
//import Alamofire

enum HTTPMethod :String {
    case GET = "GET"
    case POST = "POST"
}

//MARK:-
protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String:String]? { get }
    var needRetryWhenTokenOutOfDate:Bool { get }
}


extension Request {
    var needRetryWhenTokenOutOfDate:Bool  {
        return false
    }
}

//MARK: -
protocol UploadDatasRequest {

    var datas:[Data] { get }
    var mimeTypes:[String] { get }
    var names:[String] {get}
    var path:String { get }
}




extension Request {
    
    func convenientSend<T:ModelDecodeable>(success: @escaping (T) -> Void ,fail :@escaping (Error) -> Void) {
        
        ClientFactory.httpSharedClient.send(self) { (data, error) in
            if let error = error {
                fail(error)
                return
            }
            if let model = T.decode(from: data!) {
               success(model)
            } else {
                fatalError("模型解析错误")
            }
            
        }
    }
}

//MARK:- 
protocol Client {
    
    typealias Completion = (Data?,Error?) -> Void
    
    var host : String { get }
    
    var token: String? { get }
    
    ///如果返回的是json数据,这个方法会执行一些公共的处理逻辑
    func send(_ request:Request ,completion:@escaping Completion)
    
    ///这个方法不进行任何处理,直接返回得到的Data数据
    func sendAndGetData(_ request: Request, completion: @escaping Completion)
    
    func sendUploadData(_ request: UploadDatasRequest, completion: @escaping Completion)
}


struct ClientFactory {
    static let httpSharedClient = Network2Client(host: "http://192.168.1.134:8031")
}
